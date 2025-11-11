//
//  Theme.swift
//  MultipleStockListApp
//
//  Created by Suren Poghosyan
//

import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    case light
    case dark
    case system
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        case .system: return "Auto"
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }
    
    func next() -> AppTheme {
        switch self {
        case .system: return .light
        case .light: return .dark
        case .dark: return .system
        }
    }
}

struct ThemeColors {
    // Background Colors
    let primaryBackground: Color
    let secondaryBackground: Color
    let groupedBackground: Color
    
    // Text Colors
    let primaryText: Color
    let secondaryText: Color
    let tertiaryText: Color
    
    // Accent Colors
    let positive: Color
    let negative: Color
    let accent: Color
    
    // UI Element Colors
    let cardBackground: Color
    let cardBorder: Color
    let divider: Color
    
    // Connection Status Colors
    let connected: Color
    let disconnected: Color
    
    static func colors(for colorScheme: ColorScheme) -> ThemeColors {
        switch colorScheme {
        case .light:
            return ThemeColors(
                primaryBackground: Color(white: 0.98),
                secondaryBackground: .white,
                groupedBackground: Color(white: 0.95),
                primaryText: Color(white: 0.1),
                secondaryText: Color(white: 0.45),
                tertiaryText: Color(white: 0.6),
                positive: Color.green,
                negative: Color.red,
                accent: Color.blue,
                cardBackground: .white,
                cardBorder: Color.black.opacity(0.08),
                divider: Color.gray.opacity(0.3),
                connected: Color.green,
                disconnected: Color.gray
            )
        case .dark:
            return ThemeColors(
                primaryBackground: Color(white: 0.08),
                secondaryBackground: Color(white: 0.12),
                groupedBackground: Color(white: 0.1),
                primaryText: Color(white: 0.95),
                secondaryText: Color(white: 0.65),
                tertiaryText: Color(white: 0.5),
                positive: Color.green.opacity(0.9),
                negative: Color.red.opacity(0.9),
                accent: Color.blue.opacity(0.9),
                cardBackground: Color(white: 0.15),
                cardBorder: Color.white.opacity(0.1),
                divider: Color.gray.opacity(0.3),
                connected: Color.green.opacity(0.8),
                disconnected: Color.gray.opacity(0.6)
            )
        @unknown default:
            return colors(for: .light)
        }
    }
}