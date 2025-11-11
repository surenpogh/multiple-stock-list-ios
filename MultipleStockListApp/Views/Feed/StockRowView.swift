//
//  StockRowView.swift
//  MultipleStockListApp
//
//  Created by Suren Poghosyan on 11.11.25.
//

import SwiftUI

struct StockRowView: View {
    let stock: StockSymbol
    
    var body: some View {
        HStack {
            // Symbol Name
            VStack(alignment: .leading, spacing: 4) {
                Text(stock.name)
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text(stock.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // Price Info
            VStack(alignment: .trailing, spacing: 4) {
                Text(String(format: "$%.2f", stock.currentPrice))
                    .font(.headline)
                    .fontWeight(.bold)
                
                HStack(spacing: 2) {
                    Text(stock.isPositiveChange ? "↑" : "↓")
                        .font(.caption)
                    
                    Text(String(format: "$%.2f (%.2f%%)", abs(stock.priceChange), abs(stock.priceChangePercentage)))
                        .font(.caption)
                }
                .foregroundColor(stock.isPositiveChange ? .green : .red)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
    }
}
