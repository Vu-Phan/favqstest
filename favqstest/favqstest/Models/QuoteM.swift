//
//  QuoteM.swift
//  favqstest
//
//  Created by Vu Phan on 12/09/2021.
//

import SwiftyJSON

struct QuoteM {
    var metaId: String = ""
    var favoriteCount: Int = 0
    var dialogue: Bool = false
    var favorite: Bool = false
    var tags: [String] = []
    var url: String = ""
    var upvotesCount: Int = 0
    var downvotesCount: Int = 0
    var author: String = ""
    var authorPermalink: String = ""
    var body: String = ""
    
    init() {}
    
    init(fromJSON JSON: JSON) {
        metaId = JSON["id"].stringValue
        favoriteCount = JSON["favorites_count"].intValue
        dialogue = JSON["dialogue"].boolValue
        favorite = JSON["favorite"].boolValue
        if let tags = JSON["tags"].arrayObject as? [String] {
            self.tags = tags
        }
        url = JSON["url"].stringValue
        upvotesCount = JSON["upvotes_count"].intValue
        downvotesCount = JSON["downvotes_count"].intValue
        author = JSON["author"].stringValue
        authorPermalink = JSON["author_permalink"].stringValue
        body = JSON["body"].stringValue
    }
    
    mutating func mock() {
        metaId = "\(Date().timeIntervalSinceReferenceDate)"
        favoriteCount = 42
        dialogue = false
        favorite = true
        tags = ["tag1", "tag2", "tag3"]
        url = "someURL"
        upvotesCount = 2
        downvotesCount = 1
        author = "A great author"
        authorPermalink = "a_great_author"
        body = "This is some badass quote that make you feel awesome !"
    }
}

