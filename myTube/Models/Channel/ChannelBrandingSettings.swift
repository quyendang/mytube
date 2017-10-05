//
//  ChannelBrandingSettings.swift
//  myTube
//
//  Created by Quyen Dang on 9/29/17.
//  Copyright © 2017 Quyen Dang. All rights reserved.
//

import Foundation
import ObjectMapper

class ChannelBrandingSettings: Mappable {
    var channel: ChannelInfo?
    var image: ChannelImage?
    var hints: [ChannelHint]?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        channel <- map["channel"]
        image <- map["image"]
        hints <- map["hints"]
    }
}

class ChannelInfo: Mappable {
    var title: String?
    var description: String?
    var keywords: String?
    var defaultTab: String?
    var trackingAnalyticsAccountId: String?
    var showRelatedChannels: Bool?
    var showBrowseView: Bool?
    var featuredChannelsTitle: String?
    var featuredChannelsUrls: [String]?
    var unsubscribedTrailer: String?
    var profileColor: String?
    var country: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        description <- map["description"]
        keywords <- map["keywords"]
        defaultTab <- map["defaultTab"]
        trackingAnalyticsAccountId <- map["trackingAnalyticsAccountId"]
        showRelatedChannels <- map["showRelatedChannels"]
        showBrowseView <- map["showBrowseView"]
        featuredChannelsTitle <- map["featuredChannelsTitle"]
        featuredChannelsUrls <- map["featuredChannelsUrls"]
        unsubscribedTrailer <- map["unsubscribedTrailer"]
        profileColor <- map["profileColor"]
        country <- map["country"]
    }
}

class ChannelImage: Mappable {
    var bannerImageUrl: String?
    var bannerMobileImageUrl: String?
    var bannerTabletLowImageUrl: String?
    var bannerTabletImageUrl: String?
    var bannerTabletHdImageUrl: String?
    var bannerTabletExtraHdImageUrl: String?
    var bannerMobileLowImageUrl: String?
    var bannerMobileMediumHdImageUrl: String?
    var bannerMobileHdImageUrl: String?
    var bannerMobileExtraHdImageUrl: String?
    var bannerTvImageUrl: String?
    var bannerTvLowImageUrl: String?
    var bannerTvMediumImageUrl: String?
    var bannerTvHighImageUrl: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        bannerImageUrl <- map["bannerImageUrl"]
        bannerMobileImageUrl <- map["bannerMobileImageUrl"]
        bannerTabletLowImageUrl <- map["bannerTabletLowImageUrl"]
        bannerTabletImageUrl <- map["bannerTabletImageUrl"]
        bannerTabletHdImageUrl <- map["bannerTabletHdImageUrl"]
        bannerTabletExtraHdImageUrl <- map["bannerTabletExtraHdImageUrl"]
        bannerMobileLowImageUrl <- map["bannerMobileLowImageUrl"]
        bannerMobileMediumHdImageUrl <- map["bannerMobileMediumHdImageUrl"]
        bannerMobileHdImageUrl <- map["bannerMobileHdImageUrl"]
        bannerMobileExtraHdImageUrl <- map["bannerMobileExtraHdImageUrl"]
        bannerTvImageUrl <- map["bannerTvImageUrl"]
        bannerTvLowImageUrl <- map["bannerTvLowImageUrl"]
        bannerTvMediumImageUrl <- map["bannerTvMediumImageUrl"]
        bannerTvHighImageUrl <- map["bannerTvHighImageUrl"]
        
    }
}

class ChannelHint: Mappable {
    var property: String?
    var value: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        property <- map["property"]
        value <- map["value"]
    }
    
}
