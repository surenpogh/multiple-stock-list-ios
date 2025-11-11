//
//  FeedView.swift
//  MultipleStockListApp
//
//  Created by Suren Poghosyan on 11.11.25.
//

import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel: FeedViewModel
    
    init(stockDataService: StockDataService) {
        _viewModel = StateObject(wrappedValue: FeedViewModel(stockDataService: stockDataService))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Bar
            TopBarView(
                connectionStatusIcon: viewModel.connectionStatusIcon,
                connectionStatusText: viewModel.connectionStatusText,
                toggleButtonText: viewModel.toggleButtonText,
                onToggle: viewModel.toggleFeed
            )
            
            Divider()
            
            // Stock List
            List(viewModel.stocks) { stock in
                NavigationLink(value: NavigationDestination.symbolDetail(stock.id)) {
                    StockRowView(stock: stock)
                }
                .padding(.trailing, 12)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.visible)
                
            }
            .listStyle(.plain)
        }
        .navigationTitle("Stock Feed")
        .navigationBarTitleDisplayMode(.large)
    }
}
