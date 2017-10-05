//
//  ImageInfo.swift
//  myTube
//
//  Created by Quyen Dang on 9/24/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit
import ObjectMapper
class ImageInfo: Mappable {
    var url: String?
    var width: String?
    var height: String?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        url <- map["url"]
        width <- map["width"]
        height <- map["height"]
    }
}
