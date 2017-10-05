//
//  ChannelResponse.swift
//  myTube
//
//  Created by Quyen Dang on 9/29/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import Foundation
import ObjectMapper

class ChannelResponse: YResponse {
    var items: [Channel]?
    required init?(map: Map) {
        super.init(map: map)
    }
    override func mapping(map: Map) {
        super.mapping(map: map)
        items <- map["items"]
    }
}
