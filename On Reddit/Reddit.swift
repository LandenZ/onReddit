//
//  Reddit.swift
//  On Reddit
//
//  Created by Landen 2 Zackery on 7/28/20.
//  Copyright © 2020 stockx. All rights reserved.
//

import Foundation

class Reddit: Codable {
    var title: String = ""
    var subRedditTitle: String = ""
    var link: String = ""
    
    enum CodingKeys: String, CodingKey {
        case title
        case subRedditTitle = "subreddit_name_prefixed"
        case link = "permalink"
    }
    
    
    init(title: String, subRedditTitle: String, link: String) {
        self.title = title
        self.subRedditTitle = subRedditTitle
        self.link = link
    }
}

struct RedditPostData: Codable {
    let data: Reddit
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

struct RedditChildren: Codable {
    let children: [RedditPostData]
    
    enum CodingKeys: String, CodingKey {
        case children
    }
}

struct RedditData: Codable {
    let data: RedditChildren
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}
