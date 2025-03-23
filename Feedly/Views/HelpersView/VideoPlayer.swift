//
//  VideoPlayer.swift
//  Feedly
//
//  Created by Taha Muneeb on 23/03/2025.
//

import SwiftUI
import AVKit

struct VideoPlayer: View {
    
    var player: AVPlayer
    
    var body: some View {
        VideoPlayerView(player: player)
            .onAppear {
                player.play()
            }
            .onDisappear {
                player.pause()
            }
    }
        
}

struct VideoPlayerView: UIViewControllerRepresentable {
    
    var player: AVPlayer?
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = true
        controller.videoGravity = .resizeAspectFill
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
    }
}

#Preview {
    let url = URL(string: "https://www.w3schools.com/tags/mov_bbb.mp4")!
    let player = AVPlayer(url: url)
    VideoPlayer(player: player)
        .onAppear {
            player.play()
        }
}
