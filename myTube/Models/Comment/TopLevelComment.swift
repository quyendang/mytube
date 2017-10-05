//
//  TopLevelComment.swift
//  myTube
//
//  Created by Quyen Dang on 9/28/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit
import ObjectMapper

class TopLevelComment: Mappable {
    var kind : String?
    var etag : String?
    var id : String?
    var snippet: TopLevelCommentSnippet?
    func mapping(map: Map) {
        kind <- map["kind"]
        etag <- map["etag"]
        id <- map["id"]
        snippet <- map["snippet"]
    }
    
    required init?(map: Map) {
        
    }
}
