//
//  SymbolDetailView.swift
//  MultipleStockListApp
//
//  Created by Suren Poghosyan on 11.11.25.
//

import SwiftUI

struct SymbolDetailView: View {
    @StateObject private var viewModel: SymbolDetailViewModel
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var themeManager: ThemeManager
    
    init(symbolId: String, stockDataService: StockDataService) {
        _viewModel = StateObject(
            wrappedValue: SymbolDetailViewModel(symbolId: symbolId, stockDataService: stockDataService)
        )
    }
    
    private var themeColors: ThemeColors {
        themeManager.colors(for: colorScheme)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let stock = viewModel.stock {
                    // Price
                    Card {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionTitle("Current Price")
                            
                            HStack(alignment: .firstTextBaseline) {
                                Text(String(format: "$%.2f", stock.currentPrice))
                                    .font(.system(size: 44, weight: .bold, design: .rounded))
                                    .foregroundColor(themeColors.primaryText)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                                
                                Spacer(minLength: 12)
                                
                                VStack(alignment: .trailing, spacing: 6) {
                                    Text(viewModel.priceChangeIndicator + " " + viewModel.priceChangeText)
                                        .font(.headline)
                                }
                                .foregroundColor(stock.isPositiveChange ? themeColors.positive : themeColors.negative)
                            }
                        }
                    }
                    
                    // About
                    Card {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionTitle("About \(stock.name)")
                            
                            if !stock.description.isEmpty {
                                Text(stock.description)
                                    .font(.body)
                                    .foregroundColor(themeColors.secondaryText)
                                    .lineSpacing(3)
                            }
                            
                            if !stock.detailDescription.isEmpty {
                                Divider()
                                    .background(themeColors.divider)
                                    .padding(.vertical, 2)
                                Text(stock.detailDescription)
                                    .font(.body)
                                    .foregroundColor(themeColors.secondaryText)
                                    .lineSpacing(3)
                            }
                        }
                    }
                    
                    // Market Data
                    Card {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionTitle("Market Data")
                            
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Caption("Previous Price")
                                    Text(String(format: "$%.2f", stock.previousPrice))
                                        .font(.headline)
                                        .foregroundColor(themeColors.primaryText)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 6) {
                                    Caption("Last Updated")
                                    Text(stock.lastUpdateTime, style: .time)
                                        .font(.headline)
                                        .foregroundColor(themeColors.primaryText)
                                }
                            }
                        }
                    }
                } else {
                    Card {
                        Text("Stock not found")
                            .font(.headline)
                            .foregroundColor(themeColors.secondaryText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding(16)
        }
        .background(themeColors.groupedBackground.ignoresSafeArea())
        .navigationTitle(viewModel.stock?.name ?? "")
        .navigationBarTitleDisplayMode(.large)
        .themeColors(themeColors)
    }
}

// MARK: - Reusable Views

private struct Card<Content: View>: View {
    @Environment(\.themeColors) private var themeColors
    @ViewBuilder var content: Content
    
    var body: some View {
        content
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(themeColors.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(themeColors.cardBorder, lineWidth: 1)
            )
    }
}

private struct SectionTitle: View {
    @Environment(\.themeColors) private var themeColors
    let text: String
    init(_ text: String) { self.text = text }
    
    var body: some View {
        Text(text)
            .font(.title3.weight(.semibold))
            .foregroundColor(themeColors.primaryText)
    }
}

private struct Caption: View {
    @Environment(\.themeColors) private var themeColors
    let text: String
    init(_ text: String) { self.text = text }
    
    var body: some View {
        Text(text)
            .font(.subheadline)
            .foregroundColor(themeColors.secondaryText)
    }
}