//
//  HomeView.swift
//  Stocks App
//
//  Created by Antonio Gormley on 15/08/2021.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var model:ContentModel
    
    var body: some View {
        NavigationView {
            List {
                if !model.stockData.isEmpty {
                    ForEach(model.stockData) { stock in

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
                                Text("Change")
                            }
                            .frame(width: 100)
                        }

                    }
                    
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
