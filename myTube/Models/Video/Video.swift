//
//  Video.swift
//  myTube
//
//  Created by Quyen Dang on 9/24/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit
import ObjectMapper

class Video: Mappable {
    var kind : String?
    var etag : String?
    var id : String!
    var snippet : Snippet?
    var statistics: Statistics?
    var contentDetails: ContentDetails?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        kind <- map["kind"]
        etag <- map["etag"]
        id <- map["id"]
        snippet <- map["snippet"]
        statistics <- map["statistics"]
        contentDetails <- map["contentDetails"]
    }
}
