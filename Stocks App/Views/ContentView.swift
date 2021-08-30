//
//  ContentView.swift
//  Stocks App
//
//  Created by Antonio Gormley on 16/08/2021.
//

import SwiftUI
import StockCharts
import URLImage

struct ContentView: View {
    @EnvironmentObject var model:ContentModel
    let userDefaults = UserDefaults.standard
    
    @Binding var selectedTime:Int
    
    var symbol:String
    
    
    //    var change:Double {
    //        (closedValues.last! - closedValues.first!)/closedValues.first!
    //    }
    var body: some View {
        let hours = userDefaults.object(forKey: "\(symbol) \(model.time ?? 5) hours") as? [String]? ?? [""]
        let dates = userDefaults.object(forKey: "\(symbol) \(model.time ?? 5) dates") as? [String]? ?? [""]
        let closedValues = userDefaults.object(forKey: "\(symbol) \(model.time ?? 5)") as? [Double] ?? [0]
        let closedValue = model.stockProfileData.first?.price ?? 0
        let closedValueRounded = String(format: "%.2f", closedValue)
        ScrollView {
            LazyVStack {
                HStack {
                    Spacer()
                    let url = model.stockProfileData.first?.image ?? "https://financialmodelingprep.com/image-stock/AAPL.png"
                    let URL = URL(string: url)
                    URLImage(URL!) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 70, height: 70)
                    }
                    .padding(.trailing,30)
                    .padding(.bottom,-20)

                }
                
                Text("$\(closedValueRounded)")
                    .font(.largeTitle)
                Text("\(model.stockProfileData.first?.changes ?? 0)%")
                    .foregroundColor(.green)
                
                
                let lineChartController = LineChartController(
                    prices: closedValues,
                    dates: dates,
                    hours: hours,
                    labelColor: .blue,
                    indicatorPointColor: .blue,
                    showingIndicatorLineColor: .blue,
                    flatTrendLineColor: .blue,
                    uptrendLineColor: .blue,
                    downtrendLineColor: .red,
                    dragGesture: true
                )
                if dates != nil && hours != nil {
                LineChartView(lineChartController: lineChartController)
                    .frame(width: 400, height: 300)
                    .onAppear() {
                        model.getStockProfileData(symbol: symbol)
                    }
                }
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
                        model.time = selectedTime
                        model.loadAllSymbols()
                    }
                    
                }
                
                Section {
                    Text("About \(model.stockProfileData.first?.companyName ?? "")")
                        .bold()
                        .font(.largeTitle)
                    Text(model.stockProfileData.first?.description ?? "")
                        .padding()
                    HStack {
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                            .padding(5)
                        Text("CEO")
                            .font(.headline)
                        Spacer()
                        Text(model.stockProfileData.first?.ceo ?? "")
                            .font(.headline)
                        
                    }
                    .padding(20)
                    .frame(height:50)
                    HStack {
                        Image(systemName: "chart.pie")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                            .padding(5)
                        Text("Sector")
                            .font(.headline)
                        Spacer()
                        Text(model.stockProfileData.first?.sector ?? "")
                            .font(.headline)
                        
                    }
                    .padding(20)
                    .frame(height:50)
                    HStack {
                        Image(systemName: "gearshape.2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                            .padding(5)
                        Text("Industry")
                            .font(.headline)
                        Spacer()
                        Text(model.stockProfileData.first?.industry ?? "")
                            .font(.headline)
                        
                    }
                    .padding(20)
                    .frame(height:50)

                    HStack {
                        Image(systemName: "map")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                            .padding(5)
                        Text("Country")
                            .font(.headline)
                        Spacer()
                        Text(model.stockProfileData.first?.country ?? "")
                            .font(.headline)
                        
                    }
                    .padding(20)
                    .frame(height:50)
                    HStack {
                        Image(systemName: "person.3.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                            .padding(5)
                        Text("Employees")
                            .font(.headline)
                        Spacer()
                        Text(model.stockProfileData.first?.fullTimeEmployees ?? "")
                            .font(.headline)
                        
                    }
                    .padding(20)
                    .frame(height:50)
                    HStack {
                        Image(systemName: "building.2.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                            .padding(5)
                        Text("City")
                            .font(.headline)
                        Spacer()
                        Text(model.stockProfileData.first?.city ?? "")
                            .font(.headline)
                        
                    }
                    .padding(20)
                    .frame(height:50)
                }
                    

                Section {
                    Text("Market Stats")
                        .bold()
                        .font(.largeTitle)
                    HStack {
                        Image(systemName: "dollarsign.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                            .padding(5)
                        Text("Market Cap")
                            .font(.headline)
                        Spacer()
                        Text(String(model.stockProfileData.first?.mktCap ?? 0))
                            .font(.headline)
                        
                    }
                    .padding(20)
                    .frame(height:50)
                    HStack {
                        Image(systemName: "chart.bar")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                            .padding(5)
                        Text("Volume")
                            .font(.headline)
                        Spacer()
                        Text(String(model.stockProfileData.first?.volAvg ?? 0))
                            .font(.headline)
                        
                    }
                    .padding(20)
                    .frame(height:50)
                    HStack {
                        Image(systemName: "banknote")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                            .padding(5)
                            .aspectRatio(contentMode: .fit)
                        Text("Dividend")
                            .font(.headline)
                        Spacer()
                        Text(String(model.stockProfileData.first?.lastDiv ?? 0))
                            .font(.headline)
                        
                    }
                    .padding(20)
                    .frame(height:50)
                    
                }
            }
            .navigationBarTitle(symbol)
            Spacer()
        }
    }
}

//let symbol:String
//let price:Double
//let volAvg:Double
//let mktCap:Double
//let lastDiv:Double
//let changes:Double
//let companyName:String
//let currency:String
//let exchangeShortName:String
//let industry:String
//let website:String
//let description:String
//let ceo:String
//let sector:String
//let fullTimeEmployees:String
//let image:String
//let city:String
