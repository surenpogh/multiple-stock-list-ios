//
//  SymbolDetailView.swift
//  MultipleStockListApp
//
//  Created by Suren Poghosyan on 11.11.25.
//

import SwiftUI

struct SymbolDetailView: View {
    @StateObject private var viewModel: SymbolDetailViewModel
    
    init(symbolId: String, stockDataService: StockDataService) {
        _viewModel = StateObject(
            wrappedValue: SymbolDetailViewModel(symbolId: symbolId, stockDataService: stockDataService)
        )
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
                                    .foregroundStyle(.primary)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                                
                                Spacer(minLength: 12)
                                
                                VStack(alignment: .trailing, spacing: 6) {
                                    Text(viewModel.priceChangeIndicator + " " + viewModel.priceChangeText)
                                        .font(.headline)
                                }
                                .foregroundStyle(stock.isPositiveChange ? .green : .red)
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
                                    .foregroundStyle(.secondary)
                                    .lineSpacing(3)
                            }
                            
                            if !stock.detailDescription.isEmpty {
                                Divider().padding(.vertical, 2)
                                Text(stock.detailDescription)
                                    .font(.body)
                                    .foregroundStyle(.secondary)
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
                                        .foregroundStyle(.primary)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 6) {
                                    Caption("Last Updated")
                                    Text(stock.lastUpdateTime, style: .time)
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                }
                            }
                        }
                    }
                } else {
                    Card {
                        Text("Stock not found")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle(viewModel.stock?.name ?? "")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Reusable Views

private struct Card<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View {
        content
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(.secondarySystemGroupedBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.black.opacity(0.06), lineWidth: 1)
            )
    }
}

private struct SectionTitle: View {
    let text: String
    init(_ text: String) { self.text = text }
    var body: some View {
        Text(text)
            .font(.title3.weight(.semibold))
            .foregroundStyle(.primary)
    }
}

private struct Caption: View {
    let text: String
    init(_ text: String) { self.text = text }
    var body: some View {
        Text(text)
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }
}
