//
//  ThemeManager.swift
//  MultipleStockListApp
//
//  Created by Suren Poghosyan
//

import SwiftUI

class ThemeManager: ObservableObject {
    @AppStorage("selectedTheme") private var selectedThemeRaw: String = AppTheme.system.rawValue
    
    @Published var selectedTheme: AppTheme = .system {
        didSet {
            selectedThemeRaw = selectedTheme.rawValue
        }
    }
    
    init() {
        if let theme = AppTheme(rawValue: selectedThemeRaw) {
            self.selectedTheme = theme
        }
    }
    
    func toggleTheme() {
        selectedTheme = selectedTheme.next()
    }
    
    func colors(for colorScheme: ColorScheme) -> ThemeColors {
        return ThemeColors.colors(for: colorScheme)
    }
}