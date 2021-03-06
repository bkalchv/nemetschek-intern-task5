//
//  YouTubeListResponseItem.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 23.05.22.
//

import Foundation

class YouTubeVideoListResponseItem : Codable {
    var kind : String
    var etag : String
    var id : String
    var contentDetails : YouTubeVideoContentDetails
}
