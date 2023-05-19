//
//  HomeViewModel.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 4.05.2023.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var posts = [Post]()
    
    init() {
        fetchTweets()
    }
    
    func fetchTweets() {
        RequestService.requestDomain = "\(Path.baseUrl)\(Path.post.rawValue)"
        RequestService.fetchData { res in
            switch res {
                case .success(let data):
                    guard let posts = try? JSONDecoder().decode([Post].self, from: data as! Data) else {
                        return
                    }
                    DispatchQueue.main.async {
                        self.posts = posts
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}
