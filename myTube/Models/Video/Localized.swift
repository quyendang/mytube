//
//  Localized.swift
//  myTube
//
//  Created by Quyen Dang on 9/24/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit
import ObjectMapper

class Localized: Mappable {
    var title: String?
    var description: String?
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        description <- map["description"]
    }
}
