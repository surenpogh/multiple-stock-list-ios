//
//  MultipleStockListApp.swift
//  MultipleStockListApp
//
//  Created by Suren Poghosyan on 10.11.25.
//

import SwiftUI

@main
struct MultipleStockListApp: App {
    @StateObject private var stockDataService = StockDataService()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                FeedView(stockDataService: stockDataService)
                    .navigationDestination(for: NavigationDestination.self) { destination in
                        switch destination {
                        case .feed:
                            FeedView(stockDataService: stockDataService)
                        case .symbolDetail(let symbolId):
                            SymbolDetailView(symbolId: symbolId, stockDataService: stockDataService)
                        }
                    }
            }
        }
    }
}
