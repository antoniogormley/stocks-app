//
//  HomeView.swift
//  Stocks App
//
//  Created by Antonio Gormley on 15/08/2021.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @EnvironmentObject var model:ContentModel
    @State var selectedTime = 5

    let userDefaults = UserDefaults.standard
    
    
    var body: some View {
        NavigationView {
            List {
                HStack {
                    TextField("eg: AAPL", text: $model.symbol)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Add", action: model.addStock)
                        .disabled(!model.symbolValid)
                    
                }
                if !model.stockData.isEmpty {
                    ForEach(model.stockEntities) { stock in
                        let closedValues = userDefaults.object(forKey: "\(stock.symbol!) \(model.stockEntities.last!.time)") as? [Double] ?? [0]
                        let closeValue = closedValues.first ?? 0
                        let closedValueRounded = String(format: "%.2f", closeValue)

                        let change:Double = ((closedValues.last! - closedValues.first!)/closedValues.first!)
                        let changeRounded = String(format: "%.2f", change)

                            

                        NavigationLink(destination: ContentView(selectedTime: $selectedTime,symbol: stock.symbol ?? "")) {
                            HStack {
                                VStack {
                                    Text(String(closedValueRounded))
                                    Text("\(changeRounded)%")

                                }
                                Spacer()
                                LineChart(values: model.fiveMin2(symbol: stock.symbol ?? ""))
                                    .fill(
                                        LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.7), Color.green.opacity(0.2), Color.green.opacity(0)]), startPoint: .top, endPoint: .bottom)
                                    )
                                    .frame(width: 150, height: 50)
                                    .onAppear() {
                                        stock.time = Int64(selectedTime)
                                        print(stock.time)
                                    }
                                VStack (alignment: .trailing) {
                                    Text(stock.symbol ?? ":(")
                                }
                                .frame(width: 100)
                            }
                        }

                    }
                    .onDelete(perform: model.delete(at:))
                    
                    
                }
            }
            .navigationBarTitle("My Stocks")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    EditButton()
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
