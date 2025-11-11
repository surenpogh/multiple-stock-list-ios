//
//  SymbolDetailViewModel.swift
//  MultipleStockListApp
//
//  Created by Suren Poghosyan on 11.11.25.
//

import Foundation
import Combine

final class SymbolDetailViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var stock: StockSymbol?
    
    // MARK: - Properties
    
    private let symbolId: String
    private let stockDataService: StockDataService
    
    // MARK: - Computed Properties
    
    var priceChangeText: String {
        guard let stock = stock else { return "" }
        return String(format: "$%.2f (%.2f%%)", abs(stock.priceChange), abs(stock.priceChangePercentage))
    }
    
    var priceChangeIndicator: String {
        guard let stock = stock else { return "" }
        return stock.isPositiveChange ? "↑" : "↓"
    }
    
    // MARK: - Initialization
    
    init(symbolId: String, stockDataService: StockDataService) {
        self.symbolId = symbolId
        self.stockDataService = stockDataService
        self.stock = stockDataService.getStock(byId: symbolId)
        
        setupBindings()
    }
    
    // MARK: - Private Methods
    
    private func setupBindings() {
        stockDataService.$stocks
            .receive(on: DispatchQueue.main)
            .map { [weak self] stocks in
                guard let self = self else { return nil }
                return stocks.first { $0.id == self.symbolId }
            }
            .assign(to: &$stock)
    }
}
