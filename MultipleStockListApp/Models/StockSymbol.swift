//
//  StockSymbol.swift
//  MultipleStockListApp
//
//  Created by Suren Poghosyan on 11.11.25.
//

import Foundation

struct StockSymbol: Identifiable, Equatable {
    let id: String
    let name: String
    let description: String
    let detailDescription: String
    var currentPrice: Double
    var previousPrice: Double
    var lastUpdateTime: Date
    
    var priceChange: Double {
        currentPrice - previousPrice
    }
    
    var priceChangePercentage: Double {
        guard previousPrice > 0 else { return 0 }
        return ((currentPrice - previousPrice) / previousPrice) * 100
    }
    
    var isPositiveChange: Bool {
        priceChange >= 0
    }
    
    init(id: String, name: String, description: String, detailDescription: String, initialPrice: Double = 100.0) {
        self.id = id
        self.name = name
        self.description = description
        self.detailDescription = detailDescription
        self.currentPrice = initialPrice
        self.previousPrice = initialPrice
        self.lastUpdateTime = Date()
    }
    
    mutating func updatePrice(_ newPrice: Double) {
        self.previousPrice = self.currentPrice
        self.currentPrice = newPrice
        self.lastUpdateTime = Date()
    }
}

// MARK: - Stock Symbols Data
extension StockSymbol {
    static let allSymbols: [StockSymbol] = [
        StockSymbol(id: "AAPL",
                    name: "AAPL",
                    description: "Apple Inc.",
                    detailDescription: "Technology company that designs, manufactures, and markets smartphones, personal computers, tablets, wearables, and accessories.",
                    initialPrice: 175.43),
        StockSymbol(id: "GOOG",
                    name: "GOOG",
                    description: "Alphabet Inc.",
                    detailDescription: "Multinational conglomerate specializing in Internet-related services and products.",
                    initialPrice: 139.67),
        StockSymbol(id: "MSFT",
                    name: "MSFT",
                    description: "Microsoft Corporation",
                    detailDescription: "Leading technology company developing computer software, consumer electronics, and personal computers.",
                    initialPrice: 378.91),
        StockSymbol(id: "AMZN",
                    name: "AMZN",
                    description: "Amazon.com Inc.",
                    detailDescription: "Multinational technology company focusing on e-commerce, cloud computing, and artificial intelligence.",
                    initialPrice: 146.23),
        StockSymbol(id: "NVDA",
                    name: "NVDA",
                    description: "NVIDIA Corporation",
                    detailDescription: "American multinational technology company designing graphics processing units for gaming and professional markets.",
                    initialPrice: 495.22),
        StockSymbol(id: "TSLA",
                    name: "TSLA",
                    description: "Tesla, Inc.",
                    detailDescription: "Electric vehicle and clean energy company designing and manufacturing electric cars and battery energy storage",
                    initialPrice: 242.84),
        StockSymbol(id: "META",
                    name: "META",
                    description: "Meta Platforms Inc.",
                    detailDescription: "Technology company that develops products for connecting people through mobile devices and personal computers.",
                    initialPrice: 331.57),
        StockSymbol(id: "BRK.B",
                    name: "BRK.B",
                    description: "Berkshire Hathaway Inc.",
                    detailDescription: "Multinational conglomerate holding company overseeing and managing subsidiary companies.",
                    initialPrice: 359.12),
        StockSymbol(id: "JPM",
                    name: "JPM",
                    description: "JPMorgan Chase & Co.",
                    detailDescription: "Leading global financial services firm offering investment banking and asset management.",
                    initialPrice: 158.74),
        StockSymbol(id: "V",
                    name: "V",
                    description: "Visa Inc.",
                    detailDescription: "American multinational financial services corporation facilitating electronic funds transfers worldwide.",
                    initialPrice: 268.35),
        StockSymbol(id: "WMT",
                    name: "WMT",
                    description: "Walmart Inc.",
                    detailDescription: "American multinational retail corporation operating a chain of hypermarkets and discount department stores.",
                    initialPrice: 64.92),
        StockSymbol(id: "DIS",
                    name: "DIS",
                    description: "The Walt Disney Company",
                    detailDescription: "Diversified multinational mass media and entertainment conglomerate.",
                    initialPrice: 93.27),
        StockSymbol(id: "MA",
                    name: "MA",
                    description: "Mastercard Incorporated.",
                    detailDescription: "Multinational financial services corporation processing payments between banks.",
                    initialPrice: 412.68),
        StockSymbol(id: "NFLX",
                    name: "NFLX",
                    description: "Netflix Inc.",
                    detailDescription: "Streaming service offering a wide variety of TV shows, movies, and original content.",
                    initialPrice: 487.55),
        StockSymbol(id: "CRM",
                    name: "CRM",
                    description: "Salesforce Inc.",
                    detailDescription: "American cloud-based software company providing customer relationship management service.",
                    initialPrice: 267.93),
        StockSymbol(id: "ADBE",
                    name: "ADBE",
                    description: "Adobe Inc.",
                    detailDescription: "American multinational computer software company known for creative and multimedia software products.",
                    initialPrice: 512.34),
        StockSymbol(id: "PYPL",
                    name: "PYPL",
                    description: "PayPal Holdings Inc.",
                    detailDescription: "American multinational financial technology company operating an online payments system.",
                    initialPrice: 73.18),
        StockSymbol(id: "INTC",
                    name: "INTC",
                    description: "Intel Corporation",
                    detailDescription: "American multinational corporation and technology company designing and manufacturing semiconductor chips.",
                    initialPrice: 23.47),
        StockSymbol(id: "CSCO",
                    name: "CSCO",
                    description: "Cisco Systems Inc.",
                    detailDescription: "American multinational digital communications technology conglomerate.",
                    initialPrice: 52.89),
        StockSymbol(id: "PFE",
                    name: "PFE",
                    description: "Pfizer Inc.",
                    detailDescription: "American multinational pharmaceutical and biotechnology corporation.",
                    initialPrice: 28.94),
        StockSymbol(id: "KO",
                    name: "KO",
                    description: "The Coca-Cola Company",
                    detailDescription: "American multinational beverage corporation manufacturing and marketing nonalcoholic beverages.",
                    initialPrice: 62.73),
        StockSymbol(id: "PEP",
                    name: "PEP",
                    description: "PepsiCo Inc.",
                    detailDescription: "American multinational food, snack, and beverage corporation.",
                    initialPrice: 162.41),
        StockSymbol(id: "NKE",
                    name: "NKE",
                    description: "Nike Inc.",
                    detailDescription: "American multinational corporation engaged in design, development, and worldwide marketing of footwear and apparel.",
                    initialPrice: 78.65),
        StockSymbol(id: "AMD",
                    name: "AMD",
                    description: "Advanced Micro Devices Inc.",
                    detailDescription: "American multinational semiconductor company developing computer processors and related technologies",
                    initialPrice: 122.93),
        StockSymbol(id: "ORCL",
                    name: "ORCL",
                    description: "Oracle Corporation",
                    detailDescription: "American multinational computer technology corporation selling database software, cloud engineered systems, and enterprise software.",
                    initialPrice: 134.56)
    ]
}
