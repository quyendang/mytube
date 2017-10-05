//
//  ContentDetails.swift
//  myTube
//
//  Created by Quyen Dang on 9/28/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import Foundation
import ObjectMapper
class ContentDetails: Mappable {
    var duration: String?
    var dimension: String?
    var definition: String?
    var caption: String?
    var licensedContent: Bool?
    var projection: String?
    let stringTransform = TransformOf<String, String>(fromJSON: { (value: String?) -> String? in
        var duraString = value!.replacingOccurrences(of: "PT", with: "")
        duraString = duraString.replacingOccurrences(of: "H", with: ":")
        duraString = duraString.replacingOccurrences(of: "M", with: ":")
        duraString = duraString.replacingOccurrences(of: "S", with: "")
        return duraString
    }) { (value: String?) -> String? in
        return "\(value!)"
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        duration <- (map["duration"], stringTransform)
        dimension <- map["dimension"]
        definition <- map["definition"]
        caption <- map["caption"]
        licensedContent <- map["licensedContent"]
        projection <- map["projection"]
    }
}
