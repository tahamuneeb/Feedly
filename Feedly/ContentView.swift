//
//  ContentView.swift
//  Feedly
//
//  Created by Taha Muneeb on 20/03/2025.
//

import SwiftUI
import FeedlyCore

struct ContentView: View {
    
    let api = API()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(api.url)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
