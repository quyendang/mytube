//
//  ChannelStatistics.swift
//  myTube
//
//  Created by Quyen Dang on 9/29/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import Foundation
import ObjectMapper

class ChannelStatistics: Mappable {
    var viewCount: String?
    var commentCount: String?
    var subscriberCount: Int = 0
    var hiddenSubscriberCount: Bool?
    var videoCount: String?
    
    let stringTransform = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
        return Int(value!)
    }) { (value: Int?) -> String? in
        return "\(value!)"
    }

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        viewCount <- map["viewCount"]
        commentCount <- map["commentCount"]
        subscriberCount <- (map["subscriberCount"], stringTransform)
        hiddenSubscriberCount <- map["hiddenSubscriberCount"]
        videoCount <- map["videoCount"]
    }
}
