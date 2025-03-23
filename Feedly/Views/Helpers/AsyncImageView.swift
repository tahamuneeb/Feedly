//
//  AsyncImageView.swift
//  Feedly
//
//  Created by Taha Muneeb on 23/03/2025.
//

import SwiftUI
import FeedlyCore
import Combine

struct AsyncImageView: View {
    
    @State private var image: UIImage? = nil
    @State private var isLoading: Bool = true
    @State private var hasFailed: Bool = false
    
    private let url: String
    private let placeholder: Image
    private let imageLoader = AsyncImage()
    
    @State private var cancellables = Set<AnyCancellable>()
    
    init(url: String, placeholder: Image = Image(systemName: "placeholder")) {
        self.url = url
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if hasFailed {
                placeholder
                    .resizable()
                    .scaledToFit()
            } else if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipped()
            } else {
                ShimmerView()
                    .onAppear {
                        loadImage()
                    }
            }
        }
    }
    
    private func loadImage() {
        guard let url = URL(string: url) else {
            hasFailed = true
            return
        }
        
        imageLoader.loadImage(from: url)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure:
                        hasFailed = true
                    case .finished:
                        break
                    }
                    isLoading = false
                },
                receiveValue: { data in
                    if let downloadedImage = UIImage(data: data) {
                        self.image = downloadedImage
                    } else {
                        hasFailed = true
                    }
                }
            )
            .store(in: &cancellables)
    }
    
}


#Preview {
    AsyncImageView(
        url: "https://fastly.picsum.photos/id/444/200/300.jpg?hmac=xTzo_bbWzDyYSD5pNCUYw552_qtHzg0tQUKn5R6FOM",
        placeholder: Image("placeholder")
    )
}
