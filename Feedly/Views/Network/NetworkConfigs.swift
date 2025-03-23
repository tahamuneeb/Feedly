//
//  NetworkConfigs.swift
//  Feedly
//
//  Created by Taha Muneeb on 23/03/2025.
//

import Foundation
import FeedlyCore

struct NetworkConfigs {
    static let baseURL = URL(string: "https://api.pexels.com/v1/") ?? URL(fileURLWithPath: "")
    static let session = URLSession(configuration: .ephemeral)
    static let httpClient = URLSessionHttpClient(session: session, header: ["Authorization": "zmHfMA8OKQ1fsfA5o3GOwgyRSs2H0r4prin5SeU5lLSAVxivMg6FYz5I"])
                                                                            
}

