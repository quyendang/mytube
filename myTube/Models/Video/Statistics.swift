//
//  Statistics.swift
//  myTube
//
//  Created by Quyen Dang on 9/28/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import Foundation
import ObjectMapper
class Statistics: Mappable {
    var viewCount: Int = 0
    var likeCount: Int = 0
    var dislikeCount: Int = 0
    var favoriteCount: Int = 0
    var commentCount: Int = 0
    
    let stringTransform = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
        return Int(value!)
    }) { (value: Int?) -> String? in
        return "\(value!)"
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        viewCount <- (map["viewCount"], stringTransform)
        likeCount <- (map["likeCount"], stringTransform)
        dislikeCount <- (map["dislikeCount"], stringTransform)
        favoriteCount <- (map["favoriteCount"], stringTransform)
        commentCount <- (map["commentCount"], stringTransform)
    }
}
