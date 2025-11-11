//
//  WebSocketService.swift
//  MultipleStockListApp
//
//  Created by Suren Poghosyan on 11.11.25.
//

import Foundation
import Combine

protocol WebSocketServiceProtocol {
    var connectionState: AnyPublisher<ConnectionState, Never> { get }
    var receivedMessages: AnyPublisher<String, Never> { get }
    
    func connect()
    func disconnect()
    func send(message: String)
}

final class WebSocketService: NSObject, WebSocketServiceProtocol {
    
    // MARK: - Properties
    
    private let url: URL
    private var webSocketTask: URLSessionWebSocketTask?
    private var urlSession: URLSession?
    
    private let connectionStateSubject = CurrentValueSubject<ConnectionState, Never>(.disconnected)
    private let receivedMessagesSubject = PassthroughSubject<String, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public Publishers
    
    var connectionState: AnyPublisher<ConnectionState, Never> {
        connectionStateSubject.eraseToAnyPublisher()
    }
    
    var receivedMessages: AnyPublisher<String, Never> {
        receivedMessagesSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Initialization
    
    init(url: URL = URL(string: "wss://ws.postman-echo.com/raw")!) {
        self.url = url
        super.init()
        setupURLSession()
    }
    
    // MARK: - Private Methods
    
    private func setupURLSession() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }
    
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    self.receivedMessagesSubject.send(text)
                case .data(let data):
                    if let text = String(data: data, encoding: .utf8) {
                        self.receivedMessagesSubject.send(text)
                    }
                @unknown default:
                    break
                }
                
                self.receiveMessage()
                
            case .failure(let error):
                self.connectionStateSubject.send(.error(error.localizedDescription))
                self.disconnect()
            }
        }
    }
    
    // MARK: - Public Methods
    
    func connect() {
        guard connectionStateSubject.value != .connected else { return }
        
        connectionStateSubject.send(.connecting)
        
        webSocketTask = urlSession?.webSocketTask(with: url)
        webSocketTask?.resume()
        
        receiveMessage()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            if self.webSocketTask?.state == .running {
                self.connectionStateSubject.send(.connected)
            }
        }
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
        connectionStateSubject.send(.disconnected)
    }
    
    func send(message: String) {
        let message = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(message) { [weak self] error in
            if let error = error {
                print("WebSocket error: \(error.localizedDescription)")
                self?.connectionStateSubject.send(.error(error.localizedDescription))
            }
        }
    }
    
    deinit {
        disconnect()
    }
}

// MARK: - URLSessionWebSocketDelegate

extension WebSocketService: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        connectionStateSubject.send(.connected)
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        connectionStateSubject.send(.disconnected)
    }
}
