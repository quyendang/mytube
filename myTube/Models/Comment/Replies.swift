//
//  Replies.swift
//  myTube
//
//  Created by Quyen Dang on 9/28/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit
import ObjectMapper

class Replies: Mappable {
    var replies: [Comment]?
    func mapping(map: Map) {
        replies <- map["replies"]
    }
    required init?(map: Map) {
        
    }
}
