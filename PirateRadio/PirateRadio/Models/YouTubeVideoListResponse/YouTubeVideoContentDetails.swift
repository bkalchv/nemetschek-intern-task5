//
//  YouTubeVideoContentDetails.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 23.05.22.
//

import Foundation

struct YouTubeVideoContentDetails : Codable {
    var duration : String
    var dimension : String
    var definition : String
    var caption : String
    var licensedContent : Bool
    var contentRating : YouTubeVideoContentRating?
    var projection : String
}
