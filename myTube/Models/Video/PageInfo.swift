//
//  PageInfo.swift
//  myTube
//
//  Created by Quyen Dang on 9/25/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit
import ObjectMapper

class PageInfo: Mappable {
    var totalResults: Int?
    var resultsPerPage: Int?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        totalResults <- map["totalResults"]
        resultsPerPage <- map["resultsPerPage"]
        
    }
}
