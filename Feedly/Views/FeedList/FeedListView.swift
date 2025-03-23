//
//  FeedListView.swift
//  Feedly
//
//  Created by Taha Muneeb on 20/03/2025.
//

import SwiftUI
import FeedlyCore

struct FeedListView: View {

    @ObservedObject var viewModel = FeedListViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    ForEach(viewModel.feeds, id: \.id) { feed in
                        FeedItemView(feedItem: feed)
                            .scaledToFit()
                    }
                }
            }
            .navigationTitle("Feedly")
            .refreshable {
                viewModel.fetchFeeds()
            }
            .onAppear {
                viewModel.fetchFeeds()
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .alert("Error", isPresented: Binding<Bool>(
                get: { viewModel.error != nil },
                set: { _ in viewModel.clearError() }
            ), actions: {
                Button("OK", role: .cancel) { }
            }, message: {
                if let errorMessage = viewModel.error {
                    Text(errorMessage)
                }
            })
        }
    }
}

#Preview {
    FeedListView()
}
