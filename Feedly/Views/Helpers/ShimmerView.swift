//
//  ShimmerView.swift
//  Feedly
//
//  Created by Taha Muneeb on 23/03/2025.
//
import SwiftUI

struct ShimmerView: View {
    @State private var isAnimating: Bool = false
    
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .overlay(
                Rectangle()
                    .fill(Color.white.opacity(0.5))
                    .mask(
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [.clear, .white.opacity(0.2), .clear]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .offset(x: isAnimating ? UIScreen.main.bounds.width : (UIScreen.main.bounds.width) * -1)
                    )
            )
            .onAppear {
                withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
    }
}

#Preview {
    ShimmerView()
}
