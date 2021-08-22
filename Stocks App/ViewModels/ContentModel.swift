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
    
//    var timeSeries5min:[String:StockDataEntry]?
//
//    var fiveMinValues: [Double] {
//        timeSeries5min?.values.map {($0.close)} ?? [10,20,40,60]
//    }

    init() {
        
        getStockData()
        loadFromCoreData()
        loadAllSymbols()
        
        validateSymbolField()
        
        
    }

    
    func fiveMin() -> [Double] {
        var fiveMinValues: [Double] {
            stockData.map {($0.close)}
        }
        return fiveMinValues.reversed()

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
        getStockData()
        
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
            getStockData()
        }
    }
    
    func getStockData() {
        //string path
        let urlString = "https://financialmodelingprep.com/api/v3/historical-chart/5min/AAPL?apikey=\(APIKey)"
        let url = URL(string: urlString)
        
        guard url != nil else {
            return
        }
        //create url request object
        let request = URLRequest(url: url!)
        //get the session and kick of the task
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            //check if error
            guard error == nil else {
                return
            }
            do {
            //Create json decoder
            let decoder = JSONDecoder()
            //decode json
                let modules = try decoder.decode([StockDataEntry].self, from: data!)
                DispatchQueue.main.async {
                    self.stockData = modules
                }
            }catch{
                
                print("//couldnt parse json")
            }
        }
        //kick off data
        dataTask.resume()
    }
    
    
}

