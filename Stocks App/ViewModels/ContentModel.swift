//
//  ContentModel.swift
//  Stocks App
//
//  Created by Antonio Gormley on 14/08/2021.
//

import Foundation
import SwiftUI
import Combine

class ContentModel:ObservableObject {
    private let context = PersistenceController.shared.container.viewContext
    
    let APIKey = "FBKE3UHHHPI2WSOC"

    private var cancellables = Set<AnyCancellable>()
    
    @Published var symbolValid = false
    @Published var stockData:[StockData] = []
    @Published var symbol = ""
    @Published var stockEntities:[StockEntity] = []
    
    init() {
        loadFromCoreData()
        loadAllSymbols()
        
        validateSymbolField()
    }
    
    func validateSymbolField() {
        $symbol
            .sink { [unowned self] newValue in
                self.symbolValid = !newValue.isEmpty
            }
            .store(in: &cancellables)
    }
    
    func loadFromCoreData() {
        do {
            stockEntities = try context.fetch(StockEntity.fetchRequest())
        }catch{
            print(error)
        }
    }
    
    func addStock() {
        let newStock = StockEntity(context: context)
        newStock.symbol = symbol
        
        do {
            try context.save()

        } catch {
            print(error)
        }
        stockEntities.append(newStock)
        getStockData(for: symbol)
        
        symbol = ""
    }
    
    func delete(at indexSet: IndexSet) {
        guard let index = indexSet.first else {
            return
        }
        stockData.remove(at: index)
        let stockToRemove = stockEntities.remove(at: index)
        
        context.delete(stockToRemove)
        
        do {
            try context.save()

        } catch  {
            print(error)
        }
    }
    
    func loadAllSymbols() {
        stockData = []
        stockEntities.forEach { stockEntity in
            getStockData(for: stockEntity.symbol ?? "")
        }
    }
    
    func getStockData(for symbol:String) {
        let url = URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=\(symbol)&interval=5min&apikey='\(APIKey)")!
        URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { element -> Data in
                guard let httpResponce = element.response as? HTTPURLResponse,
                      httpResponce.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: StockData.self, decoder: JSONDecoder())
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                    return
                case .finished:
                    return
                }
            } receiveValue: { [unowned self] stockData in
                DispatchQueue.main.async {
                    self.stockData.append(stockData)
                }
            }
            .store(in: &cancellables)

        
    }
    
}

