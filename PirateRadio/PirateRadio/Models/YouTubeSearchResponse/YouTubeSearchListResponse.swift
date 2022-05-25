//
//  YouTubeSearchListResponse.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 11.05.22.
//

import Foundation

class YouTubeSearchListResponse : Codable {
    var kind : String
    var etag : String
    var nextPageToken : String
    var regionCode : String
    var pageInfo : YouTubeSearchListResponsePageInfo
    var items : [YouTubeSearchResultItem]
}
