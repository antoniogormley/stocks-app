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
    
    let APIKey = "d63572de9e75bc284f8c04a80c0df522"

    private var cancellables = Set<AnyCancellable>()
    
    @Published var symbolValid = false
    @Published var stockData:[StockDataEntry] = []
    @Published var symbol = ""
    @Published var stockEntities:[StockEntity] = []
    
    var data:[Double] = []

    
    let userDefaults = UserDefaults.standard

    
    init() {
        loadFromCoreData()
        loadAllSymbols()
//
        validateSymbolField()
    }
    
    func fiveMin() -> [Double] {
        var fiveMinValues: [Double] {
            stockData.map {($0.close)}
        }
        return fiveMinValues.reversed()

    }
    func fiveMin2(symbol:String) -> [Double] {
        var closeValues: [Double] {
                let rawValues = userDefaults.object(forKey: symbol) as? [Double] ?? [20]
                let max = rawValues.max()!
                let min = rawValues.min()!
        
                return rawValues.map { ($0 - min * 0.95) / (max - min * 0.95)}
            }
        return closeValues
    }
    
    func Dates() -> [String] {
        var Date:[String] = []
        for index in stockData.indices {
        let fullName : String = stockData[index].date
        let fullNameArr : [String] = fullName.components(separatedBy: " ")

        // And then to access the individual words:
            Date.append(fullNameArr[0])
        }
        
        return Date.reversed()

    }
    func Hours() -> [String] {
        var Date:[String] = []
        for index in stockData.indices {
        let fullName : String = stockData[index].date
        let fullNameArr : [String] = fullName.components(separatedBy: " ")

        // And then to access the individual words:
            Date.append(fullNameArr[1])
        }
        
        return Date.reversed()

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
        getStockData(symbol: symbol) {
            
        }
        
        symbol = ""
    }
    
    func delete(at indexSet: IndexSet) {
        guard let index = indexSet.first else {
            return
        }
        stockData.remove(at: index)
        let stockToRemove = stockEntities.remove(at: index)
//        stockEntities[index].symbol
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
            getStockData(symbol: stockEntity.symbol ?? "") {
                
            }
        }
    }
    
    func getStockData(symbol:String, handler: @escaping ()->Void) {
        if cancellables.count > 0 {
            cancellables.removeFirst()
        }
        stockData = []
        let urlString = "https://financialmodelingprep.com/api/v3/historical-chart/5min/\(symbol)?apikey=\(APIKey)"
        let url = URL(string: urlString)
        URLSession.shared
            .dataTaskPublisher(for: url ?? URL(fileURLWithPath: ""))
            .tryMap { element -> Data in
                guard let httpResponce = element.response as? HTTPURLResponse,
                      httpResponce.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: [StockDataEntry].self, decoder: JSONDecoder())
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
                    self.stockData.append(contentsOf: stockData)
                    self.stockData.forEach { stock in
                        data.append(stock.close)

                    }
                    self.data = self.data.reversed()
                    userDefaults.set(data, forKey: symbol)
//                    print(symbol)
//                    print(data)
                    data = []
                    handler()
                }
            }
            .store(in: &cancellables)
        

    }
}

