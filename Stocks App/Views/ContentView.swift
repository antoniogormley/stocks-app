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
    let userDefaults = UserDefaults.standard

    @Binding var selectedTime:Int

    var symbol:String
    
    
//    var change:Double {
//        (closedValues.last! - closedValues.first!)/closedValues.first!
//    }    
    var body: some View {
        let hours = model.Hours()
        let dates = model.Dates()
        let closedValues = userDefaults.object(forKey: "\(symbol) \(model.stockEntities.first!.time)") as? [Double] ?? [0]
        let closedValue = closedValues.last ?? 0
        let closedValueRounded = String(format: "%.2f", closedValue)
        
        VStack (spacing: 20) {
            HStack (spacing:20){
                Text("$\(closedValueRounded)")
                .font(.largeTitle)
//            Text("\(change)%")
                
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
            Picker("",selection: $selectedTime) {
                Text("1m").tag(1)
                Text("5m").tag(5)
                Text("15m").tag(15)
                Text("30m").tag(30)
                Text("1H").tag(5)
                Text("4H").tag(5)
                Text("1D").tag(5)

            }
            .padding()
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: selectedTime) { newValue in
                DispatchQueue.main.async {
                    model.stockEntities.first!.time = Int64(selectedTime)
                    model.loadAllSymbols()
                    print(model.Dates())
                }
                
            }
            
            LineChartView(lineChartController: lineChartController)
                            .frame(width: 400, height: 300)
                .onAppear() {
                    print(model.Dates())
                }
                
                

        }
        .navigationBarTitle(symbol)
        Spacer()
    }
}
