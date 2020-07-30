//
//  RedditTableViewViewModel.swift
//  On Reddit
//
//  Created by Landen 2 Zackery on 7/29/20.
//  Copyright © 2020 stockx. All rights reserved.
//

import Foundation

class RedditTableViewViewModel {
    
    private var redditStore: RedditStore!
    private var selectedReddit: Reddit?
    
    init(redditStore: RedditStore) {
        self.redditStore = redditStore
    }
    
    func getSelectedReddit() -> Reddit {
        return selectedReddit ?? Reddit(title: "", subRedditTitle: "", link: "")
    }
    
    func loadReddits(subRedditTitle: String = "", completion: @escaping  (Bool) -> Void) {
        
        redditStore.fetchRedditMainPosts(subRedditString: "r/\(subRedditTitle)/") { (success) in
            
            completion(success)
            
        }
    }
    
    func getNumberOfReddits() -> Int {
        return redditStore.reddits.count
    }
    
    func getRedditTitle(atRow row: Int) -> String {
        return redditStore.reddits[row].title
    }
    
    func getSubRedditTitle(atRow row: Int) -> String {
        return redditStore.reddits[row].subRedditTitle
    }
    
    func saveSelectedReddit(atRow row: Int) {
        selectedReddit = redditStore.reddits[row]
    }
}
