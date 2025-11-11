//
//  PriceUpdate.swift
//  MultipleStockListApp
//
//  Created by Suren Poghosyan on 11.11.25.
//

import Foundation

struct PriceUpdate: Codable {
    let symbol: String
    let price: Double
    let timestamp: TimeInterval
    
    init(symbol: String, price: Double, timestamp: TimeInterval = Date().timeIntervalSince1970) {
        self.symbol = symbol
        self.price = price
        self.timestamp = timestamp
    }
}
