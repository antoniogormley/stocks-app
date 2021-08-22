//
//  Test.swift
//  Stocks App
//
//  Created by Antonio Gormley on 22/08/2021.
//

import SwiftUI
import StockCharts

struct Test: View {
//    var timeSeries5min:[String:StockDataEntry]?
//
//    var fiveMinValues: [Double] {
//        timeSeries5min?.values.map {($0.close)} ?? [10,20,40,60]
//    }

    @EnvironmentObject var model:ContentModel
    var body: some View {
        NavigationView {
//            ScrollView{
//                ForEach(model.stockData) { stock in
//                    VStack{
//                        HStack{
//                        Text(String(stock.close))
//                        Image(systemName: "pencil")
//                        }
//                    }
//                }
//            }
            
            let lineChartController = LineChartController(
                prices: model.fiveMin(),
                dates: model.Dates(),
                hours: model.Hours(),
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
        }
        
    }
}

//struct Test_Previews: PreviewProvider {
//    static var previews: some View {
//        Test()
//    }
//}
