//
//  Category.swift
//  myTube
//
//  Created by Quyen Dang on 9/26/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit
import ObjectMapper

class Categories: Mappable {
    var kind : String?
    var etag : String?
    var id : String!
    var snippet : Snippet?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        kind <- map["kind"]
        etag <- map["etag"]
        id <- map["id"]
        snippet <- map["snippet"]
    }
}
