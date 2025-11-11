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
    @State private var navigationPath = NavigationPath()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationPath) {
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
            .onOpenURL { url in
                handleDeepLink(url)
            }
        }
    }
    
    // MARK: - Deep Link Handling
    
    private func handleDeepLink(_ url: URL) {
        guard url.scheme == "stocks",
              url.host == "symbol",
              let symbolId = url.pathComponents.last else {
            return
        }
        
        // Navigating to the symbol detail screen
        navigationPath.append(NavigationDestination.symbolDetail(symbolId))
    }
}
