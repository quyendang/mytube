//
//  URL+Q.swift
//  myTube
//
//  Created by Quyen Dang on 10/1/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import Foundation

extension URL {
    func dictionaryForQueryString() -> [String: Any]? {
        if let query = self.query {
            return query.dictionaryFromQueryStringComponents()
        }
        
        // Note: find youtube ID in m.youtube.com "https://m.youtube.com/#/watch?v=1hZ98an9wjo"
        let result =  absoluteString.components(separatedBy: "?")
        if result.count > 1 {
            return result.last?.dictionaryFromQueryStringComponents()
        }
        return nil
    }
}
