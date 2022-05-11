//
//  YouTubeSearchResultSnippet.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 11.05.22.
//

import Foundation

struct YouTubeSearchResultSnippet : Codable {
    var publishedAt : String
    var channelId : String
    var title : String
    var description : String
    var thumbnails : YouTubeSearchResultSnippetThumbnails
    var channelTitle : String
    var liveBroadcastContent : String
    var publishTime : String
}
