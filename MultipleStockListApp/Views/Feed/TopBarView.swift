//
//  TopBarView.swift
//  MultipleStockListApp
//
//  Created by Suren Poghosyan on 11.11.25.
//

import SwiftUI

struct TopBarView: View {
    let connectionStatusIcon: String
    let connectionStatusText: String
    let toggleButtonText: String
    let onToggle: () -> Void
    
    @Environment(\.themeColors) private var themeColors
    
    var body: some View {
        HStack {
            // Connection Status
            HStack(spacing: 4) {
                Text(connectionStatusIcon)
                    .font(.caption)
                Text(connectionStatusText)
                    .font(.caption)
                    .foregroundColor(themeColors.secondaryText)
            }
            
            Spacer()
            
            // Toggle Button
            Button(action: onToggle) {
                Text(toggleButtonText)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(toggleButtonText == "Stop" ? themeColors.negative : themeColors.connected)
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(themeColors.secondaryBackground)
    }
}