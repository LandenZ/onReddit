//
//  RedditStore.swift
//  On Reddit
//
//  Created by Landen 2 Zackery on 7/28/20.
//  Copyright © 2020 stockx. All rights reserved.
//

import Foundation

class RedditStore {
    
    var reddits = [Reddit]()
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchRedditMainPosts(subRedditString: String = "", completion: @escaping  (Bool) -> Void) {
        let baseUrlString = "https://www.reddit.com/"
        let baseUrlEndingString = ".json"
        let urlString = "\(baseUrlString)\(subRedditString)\(baseUrlEndingString)"
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let jsonData = data {
                if let liveReddits = RedditStore.getReddits(fromJSON: jsonData) {
                    self.reddits = liveReddits
                    completion(true)
                    return
                }
            } else if let requestError = error {
                print("Error fetching interesting posts: \(requestError)")
            } else {
                print("Unexpected error with the request")
            }
            completion(false)
        }
        task.resume()
    }
    
    static func getReddits(fromJSON data: Data) -> [Reddit]? {
        do {
            let decorder = JSONDecoder()
            let redditData = try decorder.decode(RedditData.self, from: data)
            var redditPosts = [Reddit]()
            for thing in redditData.data.children {
                redditPosts.append(thing.data)
            }
            return redditPosts
        } catch {
            return nil
        }
    }
}
