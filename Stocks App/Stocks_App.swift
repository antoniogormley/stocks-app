//
//  Stocks_App.swift
//  Stocks App
//
//  Created by Antonio Gormley on 14/08/2021.
//

import SwiftUI

@main
struct Stocks_App: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(ContentModel())
        }
    }
}
