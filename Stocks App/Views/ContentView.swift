//
//  ContentView.swift
//  Stocks App
//
//  Created by Antonio Gormley on 16/08/2021.
//

import SwiftUI
import StockCharts

struct ContentView: View {
    @EnvironmentObject var model:ContentModel

    var closedValues:[Double]
    var dates:[String]
    var hours:[String]
    var symbol:String
    
    var change:Double {
        (closedValues.last! - closedValues.first!)/closedValues.first!
    }
    
    var body: some View {
        
        VStack (spacing: 100) {
            HStack (spacing:20){
//                Text(String(model.fiveMin().last ?? 0))
//                .font(.largeTitle)
            Text("\(change)%")
                
            }
            let lineChartController = LineChartController(
                prices: closedValues,
                dates: dates,
                hours: hours,
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
        }.navigationBarTitle(symbol)
    }
}
