//
//  VideosResponse.swift
//  myTube
//
//  Created by Quyen Dang on 9/25/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit
import ObjectMapper

class VideosResponse: YResponse {
    var items: [Video]?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    override func mapping(map: Map) {
        super.mapping(map: map)
        items <- map["items"]
    }
    
    func fetchNextData(withCategory: String, complete: @escaping () -> Void) {
        super.fetchNextData()
        Client.shared.getMostPopularBycategory(category: withCategory, params: nil, nextPageToken: self.nextPageToken!) { (response) in
            if let nextToken = response.nextPageToken {
                if nextToken != self.nextPageToken {
                    self.nextPageToken = nextToken
                    if let preToken = response.prevPageToken {
                        self.prevPageToken = preToken
                    }
                    
                    if let videos = response.items {
                        self.items?.append(contentsOf: videos)
                    }
                }
            }
            
            complete()
        }
    }
    
    func fetchNextData(videoId: String, complete: @escaping () -> Void ) {
        super.fetchNextData()
        Client.shared.getRelatedVideosById(id: videoId, nextPageToken: self.nextPageToken) { (response) in
            if let nextToken = response.nextPageToken {
                if nextToken != self.nextPageToken {
                    self.nextPageToken = nextToken
                    if let preToken = response.prevPageToken {
                        self.prevPageToken = preToken
                    }
                    
                    if let videos = response.items {
                        self.items?.append(contentsOf: videos)
                    }
                }
            }
            
            complete()
        }
    }
}
