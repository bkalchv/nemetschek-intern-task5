//
//  YouTubeSearchResult.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 11.05.22.
//

import Foundation

class YouTubeSearchResultItem : Codable {
    var kind : String
    var etag : String
    var id : YouTubeSearchResultID
    var snippet : YouTubeSearchResultSnippet
    
    var duration : String?
}
