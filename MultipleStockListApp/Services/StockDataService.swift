//
//  StockDataService.swift
//  MultipleStockListApp
//
//  Created by Suren Poghosyan on 11.11.25.
//

import Foundation
import Combine

final class StockDataService: ObservableObject {
    
    // MARK: - Properties
    
    @Published private(set) var stocks: [StockSymbol]
    @Published private(set) var connectionState: ConnectionState = .disconnected
    @Published private(set) var isFeeding: Bool = false
    
    private let webSocketService: WebSocketServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var feedTimer: AnyCancellable?
    
    private let priceUpdateInterval: TimeInterval = 2.0
    private let priceVariationRange: ClosedRange<Double> = -5.0...5.0
    
    // MARK: - Initialization
    
    init(webSocketService: WebSocketServiceProtocol = WebSocketService()) {
        self.webSocketService = webSocketService
        self.stocks = StockSymbol.allSymbols
        
        setupBindings()
    }
    
    // MARK: - Private Methods
    
    private func setupBindings() {
        // Observing connection state
        webSocketService.connectionState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.connectionState = state
            }
            .store(in: &cancellables)
        
        // Observing received messages
        webSocketService.receivedMessages
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.handleReceivedMessage(message)
            }
            .store(in: &cancellables)
    }
    
    private func handleReceivedMessage(_ message: String) {
        guard let data = message.data(using: .utf8),
              let priceUpdate = try? JSONDecoder().decode(PriceUpdate.self, from: data) else {
            return
        }
        
        updateStock(symbol: priceUpdate.symbol, newPrice: priceUpdate.price)
    }
    
    private func updateStock(symbol: String, newPrice: Double) {
        guard let index = stocks.firstIndex(where: { $0.id == symbol }) else { return }
        stocks[index].updatePrice(newPrice)
        
        // Sorting stocks by price (highest first)
        stocks.sort { $0.currentPrice > $1.currentPrice }
    }
    
    private func generateRandomPriceUpdate(for stock: StockSymbol) -> Double {
        let variation = Double.random(in: priceVariationRange)
        let percentageChange = variation / 100.0
        let newPrice = stock.currentPrice * (1 + percentageChange)
        return max(newPrice, 0.01) // Ensuring price doesn't go negative
    }
    
    private func startPriceFeed() {
        feedTimer = Timer.publish(every: priceUpdateInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.sendPriceUpdates()
            }
    }
    
    private func stopPriceFeed() {
        feedTimer?.cancel()
        feedTimer = nil
    }
    
    private func sendPriceUpdates() {
        guard connectionState.isConnected else { return }
        
        for stock in stocks {
            let newPrice = generateRandomPriceUpdate(for: stock)
            let priceUpdate = PriceUpdate(symbol: stock.id, price: newPrice)
            
            if let jsonData = try? JSONEncoder().encode(priceUpdate),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                webSocketService.send(message: jsonString)
            }
        }
    }
    
    // MARK: - Public Methods
    
    func startFeed() {
        guard !isFeeding else { return }
        
        isFeeding = true
        webSocketService.connect()
        
        // Waiting for connection before starting feed
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.startPriceFeed()
        }
    }
    
    func stopFeed() {
        guard isFeeding else { return }
        
        isFeeding = false
        stopPriceFeed()
        webSocketService.disconnect()
    }
    
    func toggleFeed() {
        if isFeeding {
            stopFeed()
        } else {
            startFeed()
        }
    }
    
    func getStock(byId id: String) -> StockSymbol? {
        stocks.first { $0.id == id }
    }
}
