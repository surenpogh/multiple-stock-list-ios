//
//  FeedViewModel.swift
//  MultipleStockListApp
//
//  Created by Suren Poghosyan on 11.11.25.
//

import Foundation
import Combine

final class FeedViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var stocks: [StockSymbol] = []
    @Published var connectionState: ConnectionState = .disconnected
    @Published var isFeeding: Bool = false
    
    // MARK: - Properties
    
    private let stockDataService: StockDataService
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Computed Properties
    
    var connectionStatusText: String {
        switch connectionState {
        case .disconnected:
            return "Disconnected"
        case .connecting:
            return "Connecting..."
        case .connected:
            return "Connected"
        case .error(let message):
            return "Error: \(message)"
        }
    }
    
    var connectionStatusIcon: String {
        connectionState.isConnected ? "🟢" : "🔴"
    }
    
    var toggleButtonText: String {
        isFeeding ? "Stop" : "Start"
    }
    
    // MARK: - Initialization
    
    init(stockDataService: StockDataService) {
        self.stockDataService = stockDataService
        setupBindings()
    }
    
    // MARK: - Private Methods
    
    private func setupBindings() {
        stockDataService.$stocks
            .receive(on: DispatchQueue.main)
            .assign(to: &$stocks)
        
        stockDataService.$connectionState
            .receive(on: DispatchQueue.main)
            .assign(to: &$connectionState)
        
        stockDataService.$isFeeding
            .receive(on: DispatchQueue.main)
            .assign(to: &$isFeeding)
    }
    
    // MARK: - Public Methods
    
    func toggleFeed() {
        stockDataService.toggleFeed()
    }
}
