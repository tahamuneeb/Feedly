//
//  FeedListView.swift
//  Feedly
//
//  Created by Taha Muneeb on 20/03/2025.
//

import SwiftUI
import FeedlyCore

struct FeedListView: View {
    
    var array: [FeedModel] = [
        FeedModel(
            id: 1,
            url: URL(string: "https://fastly.picsum.photos/id/444/200/300.jpg?hmac=xTzo_bbWzDyYSD5pNCUYw552_qtHzg0tQUKn5R6FOM")!,
            width: 200,
            height: 300,
            creatorName: "Taha",
            thumbnailUrl: nil,
            mediaType: .image
        ),
        FeedModel(
            id: 2,
            url: URL(string: "https://fastly.picsum.photos/id/444/200/300.jpg?hmac=xTzo_bbWzDyYSD5pNCUYw552_qtHzg0tQUKn5R6FOM")!,
            width: 200,
            height: 300,
            creatorName: "Taha",
            thumbnailUrl: nil,
            mediaType: .image
        ),
        FeedModel(
            id: 3,
            url: URL(string: "https://videos.pexels.com/video-files/3571264/3571264-sd_960_540_30fps.mp4")!,
            width: 960,
            height: 540,
            creatorName: "Taha M",
            thumbnailUrl: URL(string: "https://fastly.picsum.photos/id/444/200/300.jpg?hmac=xTzo_bbWzDyYSD5pNCUYw552_qtHzg0tQUKn5R6FOM")!,
            mediaType: .video
        )
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(array, id: \.id) { feed in
                        FeedItemView(feedItem: feed)
                            .scaledToFit()
                    }
                }
            }
            .navigationTitle("Feedly")
        }
        
    }
}

#Preview {
    FeedListView()
}
