//
//  DataResponse.swift
//  myTube
//
//  Created by Quyen Dang on 9/25/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit
import ObjectMapper

class YResponse: Mappable {
    
    var kind: String?
    var etag: String?
    var nextPageToken: String?
    var prevPageToken: String?
    var pageInfo: PageInfo?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        kind <- map["kind"]
        etag <- map["etag"]
        nextPageToken <- map["nextPageToken"]
        prevPageToken <- map["prevPageToken"]
        pageInfo <- map["pageInfo"]
    }
    func fetchNextData() {
        if nextPageToken == nil {
            return
        }
    }
}

