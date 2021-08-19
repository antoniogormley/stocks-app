//
//  ContentView.swift
//  Stocks App
//
//  Created by Antonio Gormley on 16/08/2021.
//

import SwiftUI
import StockCharts

struct ContentView: View {
    var stockname:String
    var closedValues:[Double]
    var latestClose:String
    
    var change:Double {
        (closedValues.last! - closedValues.first!)/closedValues.first!
    }
    
    var body: some View {
        
        VStack (spacing: 100) {
            HStack (spacing:20){
            Text(latestClose)
                .font(.largeTitle)
            Text("\(change)%")
                
            }
            let lineChartController = LineChartController(
                prices: closedValues,
                dates: nil,
                hours: nil,
                labelColor: .green,
                indicatorPointColor: .green,
                showingIndicatorLineColor: .green,
                flatTrendLineColor: .green,
                uptrendLineColor: .green,
                downtrendLineColor: .green,
                dragGesture: true
            )
            LineChartView(lineChartController: lineChartController)
                            .frame(width: 400, height: 300)
        }.navigationBarTitle(stockname)
    }
}
