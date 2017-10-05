//
//  Client.swift
//  myTube
//
//  Created by Quyen Dang on 9/23/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
class Client: BaseClient {
    static let shared = Client()
    var currentToken: String?
    var categoryList = [Categories]()
    func getMostPopularBycategory(category: String, params: [String: String]?, nextPageToken: String?, complete: @escaping (VideosResponse) -> Void) {
        var requestUrl = ""
        if let token = nextPageToken {
            requestUrl = "\(String(format: self.mostPopularUrl, category))&pageToken=\(token)"
        } else{
            requestUrl = String(format: self.mostPopularUrl, category)
        }
        let header = ["Referer": "https://developers.google.com/"]
        Alamofire.request(requestUrl, method: .get, parameters: params, encoding: URLEncoding.default, headers: header).responseObject { (response : DataResponse<VideosResponse>) in
            if let resultResponse = response.result.value {
                complete(resultResponse)
            }
        }
    }
    
    func getSubscriptionsUrl(nextPageToken: String?, complete: @escaping (SubscriptionsResponse) -> Void, error: (Error) -> Void) {
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            var requestUrl = ""
            if let token = nextPageToken {
                requestUrl = "\(self.subscriptionsUrl)&pageToken=\(token)"
            } else{
                requestUrl = self.subscriptionsUrl
            }
            
            let header = ["Referer": "http://google.com", "Authorization": "Bearer \(GIDSignIn.sharedInstance().currentUser.authentication.accessToken!)"]
            Alamofire.request(requestUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseObject { (response : DataResponse<SubscriptionsResponse>) in
                if let resultResponse = response.result.value {
                    complete(resultResponse)
                }
            }
        }
    }
    
    func getCommentListByVideoId(id: String, nextPageToken: String?, complete: @escaping (CommentResponse) -> Void) {
        var requestUrl = ""
        if let token = nextPageToken {
            requestUrl = "\(String(format: self.getCommentListUrl, id))&pageToken=\(token)"
        } else{
            requestUrl = String(format: self.getCommentListUrl, id)
        }
        let header = ["Referer": "https://developers.google.com/"]
        Alamofire.request(requestUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseObject { (response : DataResponse<CommentResponse>) in
            if let resultResponse = response.result.value {
                complete(resultResponse)
            }
        }
    }
    
    func getRelatedVideosById(id: String, nextPageToken: String?, complete: @escaping (VideosResponse) -> Void) {
        var requestUrl = ""
        if let token = nextPageToken {
            requestUrl = "\(String(format: self.getRelatedVideoUrl, id))&pageToken=\(token)"
        } else{
            requestUrl = String(format: self.getRelatedVideoUrl, id)
        }
        let header = ["Referer": "https://developers.google.com/"]
        Alamofire.request(requestUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseObject { (response : DataResponse<VideosResponse>) in
            if let resultResponse = response.result.value {
                complete(resultResponse)
            }
        }
    }
    
    func getAllCategoriesByRegion(region: String, language: String, complete: @escaping ([Categories]?) -> Void) {
        let requestUrl = String(format: self.categoryListUrl, language, region)
        let header = ["Referer": "https://developers.google.com/"]
        Alamofire.request(requestUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseObject { (response : DataResponse<CategorysResponse>) in
            if let resultResponse = response.result.value {
                self.categoryList.append(contentsOf: resultResponse.items!)
                complete(resultResponse.items)
            }
        }
    }
    
    func getChannelInfo(id: String, complete: @escaping (ChannelResponse) -> Void) {
        let requestUrl = String(format: self.getChannelInfoUrl, id)
        let header = ["Referer": "https://developers.google.com/"]
        Alamofire.request(requestUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseObject { (response : DataResponse<ChannelResponse>) in
            if let resultResponse = response.result.value {
                complete(resultResponse)
            }
        }
    }
    
}


