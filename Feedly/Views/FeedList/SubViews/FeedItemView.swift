//
//  FeedItemView.swift
//  Feedly
//
//  Created by Taha Muneeb on 23/03/2025.
//

import SwiftUI
import FeedlyCore
import AVKit

struct FeedItemView: View {
    
    var feedItem: FeedModel
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            Text(feedItem.creatorName)
                .font(.headline)
                .padding()
            Group {
                if feedItem.mediaType == .image {
                    AsyncImageView(url: feedItem.url.absoluteString)
                        .aspectRatio(
                            CGFloat(feedItem.width) / CGFloat(feedItem.height),
                            contentMode: .fit
                        )
                        .frame(maxWidth: .infinity)
                } else {
                    VideoPlayer(player: AVPlayer(url: feedItem.url))
                        .aspectRatio(
                            CGFloat(feedItem.width) / CGFloat(feedItem.height),
                            contentMode: .fill
                        )
                }
            }
            
        }
        
    }
}

#Preview {
    FeedItemView(
        feedItem: FeedModel(
            id: 1,
            url: URL(string: "https://fastly.picsum.photos/id/444/200/300.jpg?hmac=xTzo_bbWzDyYSD5pNCUYw552_qtHzg0tQUKn5R6FOM")!,
            width: 200,
            height: 300,
            creatorName: "Taha",
            thumbnailUrl: nil,
            mediaType: .image
        )
    )
}

#Preview {
    FeedItemView(
        feedItem: FeedModel(
            id: 2,
            url: URL(string: "https://videos.pexels.com/video-files/3571264/3571264-sd_960_540_30fps.mp4")!,
            width: 960,
            height: 540,
            creatorName: "Taha",
            thumbnailUrl: URL(string: "https://fastly.picsum.photos/id/444/200/300.jpg?hmac=xTzo_bbWzDyYSD5pNCUYw552_qtHzg0tQUKn5R6FOM")!,
            mediaType: .video
        )
    )
}
