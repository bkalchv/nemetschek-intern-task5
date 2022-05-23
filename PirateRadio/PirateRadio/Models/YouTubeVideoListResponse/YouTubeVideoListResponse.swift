//
//  YouTubeListResponse.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 23.05.22.
//

import Foundation

struct YouTubeVideoListResponse : Codable {
    var kind : String
    var etag : String
    var items : [YouTubeVideoListResponseItem]
    var pageInfo : YouTubeVideoPageInfo
}
