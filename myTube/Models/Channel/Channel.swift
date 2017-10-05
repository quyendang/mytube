//
//  Channel.swift
//  myTube
//
//  Created by Quyen Dang on 9/29/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import Foundation
import ObjectMapper
class Channel: Mappable {
    var kind : String?
    var etag : String?
    var id : String?
    var statistics: ChannelStatistics?
    var brandingSettings: ChannelBrandingSettings?
    var snippet: Snippet?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        kind <- map["kind"]
        etag <- map["etag"]
        id <- map["id"]
        statistics <- map["statistics"]
        brandingSettings <- map["brandingSettings"]
        snippet <- map["snippet"]
    }
}
