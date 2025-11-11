//
//  ThemeEnvironmentKey.swift
//  MultipleStockListApp
//
//  Created by Suren Poghosyan
//

import SwiftUI

private struct ThemeColorsKey: EnvironmentKey {
    static let defaultValue: ThemeColors = ThemeColors.colors(for: .light)
}

extension EnvironmentValues {
    var themeColors: ThemeColors {
        get { self[ThemeColorsKey.self] }
        set { self[ThemeColorsKey.self] = newValue }
    }
}

extension View {
    func themeColors(_ colors: ThemeColors) -> some View {
        environment(\.themeColors, colors)
    }
}