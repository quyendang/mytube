//
//  CategorysResponse.swift
//  myTube
//
//  Created by Quyen Dang on 9/26/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit
import ObjectMapper
class CategorysResponse: YResponse {
    var items: [Categories]?
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        items <- map["items"]
    }
}
