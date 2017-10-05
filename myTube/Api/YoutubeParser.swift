//
//  YoutubeParser.swift
//  myTube
//
//  Created by Quyen Dang on 9/29/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit
import Alamofire
import XCDYouTubeKit
public class YoutubeParser: NSObject {
    static let shared = YoutubeParser()
    func getVideos(videoId: String) {
        XCDYouTubeClient.default().getVideoWithIdentifier(videoId) { (video, error) in
            if video != nil {
                var videosList: [[String: Any]] = []
                for v in (video?.videoLinks)! {
                    if let videoDic = v as? [String: Any]{
                        var videoComponents = [String: Any]()
                        videoComponents["title"] = video?.title
                        videoComponents["url"] = videoDic["url"]
                        videoComponents["quality"] = videoDic["quality"]
                        videosList.append(videoComponents)
                    }
                }
            } else {
                
            }
        }
    }
    
    
    func h264videos(videoId: String, complete: @escaping ([[String: Any]]) -> Void) {
        XCDYouTubeClient.default().getVideoWithIdentifier(videoId) { (video, error) in
            if video != nil {
                var videosList: [[String: Any]] = []
                for v in (video?.videoLinks)! {
                    if let videoDic = v as? [String: Any]{
                        var videoComponents = [String: Any]()
                        videoComponents["title"] = video?.title
                        videoComponents["url"] = videoDic["url"]
                        videoComponents["quality"] = videoDic["quality"]
                        videosList.append(videoComponents)
                    }
                }
                complete(videosList)
            } else {
                
            }
        }
//        let requestUrl = "http://www.youtube.com/get_video_info?video_id=\(videoId)&hl=en&el=embedded&ps=default"
//        //let requestUrl = "https://www.youtube.com/watch?v=\(videoId)"
//        let headers = ["Accept-Language": "en"]
//        var videosList: [[String: Any]] = []
////        Alamofire.request(requestUrl, headers: headers).responseString { (response) in
////            if let str = response.result.value {
////                if let jsonStr = str.slice(from: "ytplayer.config =", to: ";ytplayer.load") {
////                    var data = jsonStr.data(using: .utf8)!
////                    if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
////                        if let args = json!["args"] as? [String: Any]{
////                            var videoTitle: String = ""
////                            var streamImage: String = ""
////                            if let title = args["title"] as? String {
////                                videoTitle = title
////                            }
////                            if let image = args["iurl"] as? String {
////                                streamImage = image
////                            }
////
////                            if let fmtStreamMap = args["url_encoded_fmt_stream_map"] as? String {
////                                if let _: Any = args["live_playback"]{
////                                    if let hlsvp = args["hlsvp"] as? String {
////                                        let data = ["url": "\(hlsvp)", "title": "\(videoTitle)", "image": "\(streamImage)", "isStream": true] as [String : Any]
////                                        complete([data])
////                                    }
////                                } else {
////                                    let fmtStreamMapArray = fmtStreamMap.components(separatedBy: ",")
////                                    for videoEncodedString in fmtStreamMapArray {
////                                        var videoComponents = videoEncodedString.dictionaryFromQueryStringComponents()
////                                        videoComponents["title"] = "videoTitle"
////                                        videoComponents["isStream"] = false
////                                        videosList.append(videoComponents)
////                                    }
////                                    print(videosList)
////                                    complete(videosList)
////                                }
////                            }
////                        }
////                    }
////                }
////            }
////        }
//        Alamofire.request(requestUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseString { (response) in
//            if let responseString = response.result.value {
//                let parts = responseString.dictionaryFromQueryStringComponents()
//                if parts.count > 0 {
//                    var videoTitle: String = ""
//                    var streamImage: String = ""
//                    if let title = parts["title"] as? String {
//                        videoTitle = title
//                    }
//                    if let image = parts["iurl"] as? String {
//                        streamImage = image
//                    }
//                    if let fmtStreamMap = parts["url_encoded_fmt_stream_map"] as? String {
//                        // Live Stream
//                        if let _: Any = parts["live_playback"]{
//                            if let hlsvp = parts["hlsvp"] as? String {
//                                let data = ["url": "\(hlsvp)", "title": "\(videoTitle)", "image": "\(streamImage)", "isStream": true] as [String : Any]
//                                complete([data])
//                            }
//                        } else {
//                            let fmtStreamMapArray = fmtStreamMap.components(separatedBy: ",")
//                            for videoEncodedString in fmtStreamMapArray {
//                                var videoComponents = videoEncodedString.dictionaryFromQueryStringComponents()
//                                videoComponents["title"] = videoTitle
//                                videoComponents["isStream"] = false
//
//                                videosList.append(videoComponents)
//                            }
//                            complete(videosList)
//                        }
//                    }
//                }
//            }
//        }
    }
}
