//
//  StockData.swift
//  Stocks App
//
//  Created by Antonio Gormley on 15/08/2021.
//

import Foundation

struct StockDataEntry: Identifiable,Decodable,Hashable {
    
        let date:String
        let open:Double
        let high:Double
        let low:Double
        let close:Double
        let volume:Double
    
    // CodingKey to ignore id when decoding
    enum CodingKeys : String, CodingKey {
        case date
        case open
        case high
        case low
        case close
        case volume
    }
    
    var id = UUID()
}


