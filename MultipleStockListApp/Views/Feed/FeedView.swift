//
//  FeedView.swift
//  MultipleStockListApp
//
//  Created by Suren Poghosyan on 11.11.25.
//

import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel: FeedViewModel
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var themeManager: ThemeManager
    
    init(stockDataService: StockDataService) {
        _viewModel = StateObject(wrappedValue: FeedViewModel(stockDataService: stockDataService))
    }
    
    private var themeColors: ThemeColors {
        themeManager.colors(for: colorScheme)
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
                .background(themeColors.divider)
            
            // Stock List
            List(viewModel.stocks) { stock in
                NavigationLink(value: NavigationDestination.symbolDetail(stock.id)) {
                    StockRowView(stock: stock)
                }
                .padding(.trailing, 12)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.visible)
                .listRowBackground(themeColors.secondaryBackground)
            }
            .listStyle(.plain)
            .background(themeColors.primaryBackground)
            .scrollContentBackground(.hidden)
        }
        .background(themeColors.primaryBackground)
        .navigationTitle("Stock Feed")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    themeManager.toggleTheme()
                } label: {
                    Text(themeManager.selectedTheme.displayName)
                        .foregroundColor(themeColors.accent)
                        .fontWeight(.medium)
                }
            }
        }
        .themeColors(themeColors)
    }
}