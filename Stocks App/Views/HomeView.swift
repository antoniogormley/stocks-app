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
                        .disabled(model.validateSymbolField())
                    
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
                                    ZStack {
                                        Rectangle()
                                            .foregroundColor(.green)
                                            .cornerRadius(7)

                                            
                                        Text("\(changeRounded)%")
                                            .foregroundColor(.white)
                                            .padding(4)

                                    }

                                }
                                Spacer()
                                Spacer()
                                LineChart(values: model.fiveMin2(symbol: stock.symbol ?? ""))
                                    .fill(
                                        LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue.opacity(0.2), Color.blue.opacity(0)]), startPoint: .top, endPoint: .bottom)
                                    )
                                    .frame(width: 120, height: 50)
                                    .onAppear() {
                                        print(stock.time)
                                    }
                                VStack (alignment: .trailing) {
                                    Text(stock.symbol ?? ":(")
                                        .font(.title2)
//                                        .bold()
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
        .onAppear() {
            model.time = selectedTime
            print(model.time)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
