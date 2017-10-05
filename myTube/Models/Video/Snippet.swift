//
//  Snippet.swift
//  myTube
//
//  Created by Quyen Dang on 9/24/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit
import ObjectMapper
class Snippet: Mappable {
    var publishedAt: Date?
    var channelId: String?
    var title: String?
    var description: String?
    var thumbnails: Thumbnails?
    var channelTitle: String?
    var tags: [String]?
    var categoryId: Int?
    var liveBroadcastContent: String?
    var defaultAudioLanguage: String?
    var localized: Localized?
    var assignable: Bool?
    
    
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
        
    }
    
    func mapping(map: Map) {
        publishedAt <- (map["publishedAt"], dateTransform)
        channelId <- map["channelId"]
        title <- map["title"]
        description <- map["description"]
        thumbnails <- map["thumbnails"]
        channelTitle <- map["channelTitle"]
        tags <- map["tags"]
        categoryId <- map["categoryId"]
        liveBroadcastContent <- map["liveBroadcastContent"]
        defaultAudioLanguage <- map["defaultAudioLanguage"]
        localized <- map["localized"]
        assignable <- map["assignable"]
    }
}
