//
//  TopLevelCommentSnippet.swift
//  myTube
//
//  Created by Quyen Dang on 9/28/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit
import ObjectMapper

class TopLevelCommentSnippet: Mappable {
    var authorDisplayName: String?
    var authorProfileImageUrl: String?
    var authorChannelUrl: String?
    var videoId: String?
    var textDisplay: String?
    var textOriginal: String?
    var canRate: Bool?
    var viewerRating: String?
    var likeCount: Int?
    var publishedAt: Date?
    var updatedAt: Date?
    var authorChannelId: String?
    
    let dateTransform = TransformOf<Date, String>(fromJSON: { (value: String?) -> Date? in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter.date(from: value!)
    }) { (value: Date?) -> String? in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter.string(from: value!)
    }
    
    required init?(map: Map) {
        authorDisplayName <- map["authorDisplayName"]
        authorProfileImageUrl <- map["authorProfileImageUrl"]
        authorChannelUrl <- map["authorChannelUrl"]
        videoId <- map["videoId"]
        textDisplay <- map["textDisplay"]
        textOriginal <- map["textOriginal"]
        canRate <- map["canRate"]
        viewerRating <- map["viewerRating"]
        likeCount <- map["likeCount"]
        publishedAt <- (map["publishedAt"], dateTransform)
        updatedAt <- (map["updatedAt"], dateTransform)
        authorChannelId <- map["authorChannelId.value"]
    }
    
 func mapping(map: Map) {
        
    }
}
