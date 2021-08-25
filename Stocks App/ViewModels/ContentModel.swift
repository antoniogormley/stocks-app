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
    
    let APIKey = "bc50df22b34886a6947966c591119b42"

    private var cancellables = Set<AnyCancellable>()
    
    @Published var symbolValid = false
    @Published var stockData:[StockDataEntry] = []
    @Published var symbol = ""
    @Published var stockEntities:[StockEntity] = []
    
    var data:[Double] = []

    
    let userDefaults = UserDefaults.standard

    
    init() {
        loadFromCoreData()
//        loadAllSymbols()
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
        getStockData(symbol: symbol)
        
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
            getStockData(symbol: stockEntity.symbol ?? "")
        }
    }
    
    func getStockData(symbol:String) {
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
                    userDefaults.set(data, forKey: symbol)
                    print(symbol)
                    print(data)
                    data = []
                }
            }
            .store(in: &cancellables)


    }
//    func getStockData(symbol:String) {
//        //string path
//        let urlString = "https://financialmodelingprep.com/api/v3/historical-chart/5min/\(symbol)?apikey=\(APIKey)"
//        let url = URL(string: urlString)
//
//        guard url != nil else {
//            return
//        }
//        //create url request object
//        let request = URLRequest(url: url!)
//        //get the session and kick of the task
//        let session = URLSession.shared
//
//        let dataTask = session.dataTask(with: request) { data, response, error in
//            //check if error
//            guard error == nil else {
//                return
//            }
//            do {
//            //Create json decoder
//            let decoder = JSONDecoder()
//            //decode json
//                let modules = try decoder.decode([StockDataEntry].self, from: data!)
//                DispatchQueue.main.async {
//                    self.stockData = modules
//
//                    self.stockData.forEach { stock in
//                        self.data.append(stock.close)
//
//                    }
//                    self.userDefaults.set(data, forKey: symbol)
//                    print(symbol)
//                    self.data = []
//                }
//            }catch{
//                //couldnt parse json
//            }
//        }
//        //kick off data
//        dataTask.resume()
//    }
//
}

