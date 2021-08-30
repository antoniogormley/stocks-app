//
//  StockData.swift
//  Stocks App
//
//  Created by Antonio Gormley on 30/08/2021.
//

import Foundation

struct StockData: Identifiable,Decodable,Hashable {
    
    let symbol:String
    let price:Double
    let volAvg:Double
    let mktCap:Double
    let lastDiv:Double
    let changes:Double
    let companyName:String
    let currency:String
    let exchangeShortName:String
    let industry:String
    let website:String
    let description:String
    let ceo:String
    let sector:String
    let fullTimeEmployees:String
    let image:String
    let city:String
    let country:String

    

    
    // CodingKey to ignore id when decoding
    enum CodingKeys : String, CodingKey {
        case symbol
        case price
        case volAvg
        case mktCap
        case lastDiv
        case changes
        case companyName
        case currency
        case exchangeShortName
        case industry
        case website
        case description
        case ceo
        case sector
        case fullTimeEmployees
        case image
        case city
        case country

    }
    
    var id = UUID()
}
