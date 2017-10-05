//
//  BaseClient.swift
//  myTube
//
//  Created by Quyen Dang on 9/23/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import Foundation


class BaseClient  {
    var currentApiKey = "AIzaSyD-a9IF8KKYgoC3cpgS-Al7hLQDbugrDcw"
    var subscriptionsUrl = "https://www.googleapis.com/youtube/v3/subscriptions?part=snippet%2CcontentDetails&maxResults=10&mine=true&key=AIzaSyD8p1M5L_kIeFLKsXuF_OI-27cYAbydC_8"
    var mostPopularUrl = "https://www.googleapis.com/youtube/v3/videos?part=snippet,statistics,contentDetails&chart=mostPopular&regionCode=vn&videoCategoryId=%@&key=AIzaSyD-a9IF8KKYgoC3cpgS-Al7hLQDbugrDcw&maxResults=10"
    var categoryListUrl = "https://www.googleapis.com/youtube/v3/videoCategories?part=snippet&hl=%@&regionCode=%@&key=AIzaSyD-a9IF8KKYgoC3cpgS-Al7hLQDbugrDcw"
    var getCommentListUrl = "https://www.googleapis.com/youtube/v3/commentThreads?part=snippet,replies&videoId=%@&key=AIzaSyD-a9IF8KKYgoC3cpgS-Al7hLQDbugrDcw"
    var getChannelInfoUrl = "https://www.googleapis.com/youtube/v3/channels?part=brandingSettings,statistics,snippet&id=%@&key=AIzaSyD-a9IF8KKYgoC3cpgS-Al7hLQDbugrDcw"
    var getRelatedVideoUrl = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=10&relatedToVideoId=%@&type=video&key=AIzaSyD-a9IF8KKYgoC3cpgS-Al7hLQDbugrDcw"
}
