//
//  SubscriptionsResponse.swift
//  myTube
//
//  Created by Quyen Dang on 9/25/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit
import ObjectMapper

class SubscriptionsResponse: YResponse {
    var items: [Subscription]?
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        items <- map["items"]
    }
    func fetchNextData(complete: @escaping () -> Void) {
        super.fetchNextData()
        Client.shared.getSubscriptionsUrl(nextPageToken: self.nextPageToken!, complete: { (response) in
            if let nextToken = response.nextPageToken {
                if nextToken != self.nextPageToken {
                    
                    self.nextPageToken = nextToken
                    if let subs = response.items{
                        self.items?.append(contentsOf: subs)
                    }
                    
                    if let preToken = response.prevPageToken {
                        self.prevPageToken = preToken
                    }
                }
            }
            
            complete()
        }) { (error) in
            
        }
    }
}
