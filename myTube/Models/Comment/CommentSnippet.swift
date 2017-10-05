//
//  CommentSnippet.swift
//  myTube
//
//  Created by Quyen Dang on 9/28/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit
import ObjectMapper

class CommentSnippet: Mappable {
    var videoId: String?
    var topLevelComment: TopLevelComment?
    var canReply: Bool?
    var totalReplyCount: Int?
    var isPublic: Bool?
    
    func mapping(map: Map) {
        videoId <- map["videoId"]
        topLevelComment <- map["topLevelComment"]
        canReply <- map["canReply"]
        totalReplyCount <- map["totalReplyCount"]
        isPublic <- map["isPublic"]
    }
    
    required init?(map: Map) {
        
    }
}
