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
                    ForEach(model.stockData) { stock in

                        NavigationLink(destination: ContentView(stockname: stock.metaData.symbol,closedValues: stock.fiveMinValues,latestClose: stock.latestClose)) {
                            HStack {
                                Text(stock.metaData.symbol)
                                Spacer()
                                LineChart(values: stock.closeValues)
                                    .fill(
                                        LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.7), Color.green.opacity(0.2), Color.green.opacity(0)]), startPoint: .top, endPoint: .bottom)
                                    )
                                    .frame(width: 150, height: 50)
                                VStack (alignment: .trailing) {
                                    Text(stock.latestClose)
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
