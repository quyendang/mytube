//
//  CommentResponse.swift
//  myTube
//
//  Created by Quyen Dang on 9/28/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit
import ObjectMapper

class CommentResponse: YResponse {
    var items: [Comment]?
    required init?(map: Map) {
        super.init(map: map)
    }
    override func mapping(map: Map) {
        super.mapping(map: map)
        items <- map["items"]
    }
    
    func fetchNextData(videoId: String, complete: @escaping () -> Void) {
        super.fetchNextData()
        Client.shared.getCommentListByVideoId(id: videoId, nextPageToken: self.nextPageToken) { (response) in
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
