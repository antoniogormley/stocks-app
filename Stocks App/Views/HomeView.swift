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
    let userDefaults = UserDefaults.standard

    
    var body: some View {
        NavigationView {
            List {
                HStack {
                    TextField("Symbol", text: $model.symbol)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Add", action: model.addStock)
                        .disabled(!model.symbolValid)
                    
                }
                if !model.stockData.isEmpty {
                    ForEach(model.stockEntities) { stock in

                        NavigationLink(destination: ContentView(closedValues: userDefaults.object(forKey: stock.symbol ?? "BP") as! [Double], dates: model.Dates(), hours: model.Hours(),symbol: stock.symbol ?? "")) {
                            HStack {
                                Text(model.symbol)
                                Spacer()
                                LineChart(values: model.fiveMin2(symbol: stock.symbol ?? ""))
//                                    TO DO make it adaptive to symbol
                                    .fill(
                                        LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.7), Color.green.opacity(0.2), Color.green.opacity(0)]), startPoint: .top, endPoint: .bottom)
                                    )
                                    .frame(width: 150, height: 50)
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
