//
//  FeedListViewModel.swift
//  Feedly
//
//  Created by Taha Muneeb on 23/03/2025.
//

import Foundation
import FeedlyCore
import SwiftUI
import Combine

class FeedListViewModel: ObservableObject {
    @Published private(set) var feeds: [FeedModel] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var error: String?
    
    private let httpClient = NetworkConfigs.httpClient
    private var cancellable: AnyCancellable?
    private let collectionId = "w4vhdae"
    
    func fetchFeeds() {
        isLoading = true
        let url = FeedEndpoint.get(collectionId).url(baseURL: NetworkConfigs.baseURL)
        
        cancellable = httpClient
            .getPublisher(url: url)
            .receive(on: DispatchQueue.main)
            .tryMap(FeedDataMapper.map)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let failure):
                    self?.error = failure.localizedDescription
                }
                self?.isLoading = false
            }, receiveValue: { [weak self] data in
                self?.isLoading = false
                self?.feeds = data
            })
        
    }
    
    func clearError() {
        error = nil
    }
    
}
