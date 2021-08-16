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
    
    @Published var stockData:[StockData] = []
    @Published var symbol = ""
    @Published var stockEntities:[StockEntity] = []
    
    init() {
        loadFromCoreData()
        loadAllSymbols()
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
        getStockData(for: symbol)
        
        symbol = ""
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

