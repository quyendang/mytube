//
//  Thumbnails.swift
//  myTube
//
//  Created by Quyen Dang on 9/24/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit
import ObjectMapper
class Thumbnails: Mappable {
    var _default: ImageInfo?
    var medium: ImageInfo?
    var high: ImageInfo?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        _default <- map["default"]
        medium <- map["medium"]
        high <- map["high"]
    }
}
