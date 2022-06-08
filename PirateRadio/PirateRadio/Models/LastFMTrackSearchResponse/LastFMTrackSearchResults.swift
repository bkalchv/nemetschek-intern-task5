//
//  LastFMTrackSearch.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 8.06.22.
//

import Foundation

class LastFMTrackSearchResults : Codable {
    var opensearchQuery: LastFMTrackSearchQuery
    var opensearchTotalResults: String
    var opensearchStartIndex: String
    var opensearchItemsPerPage: String
    var trackmatches: LastFMTrackSearchTrackmatches
    // TODO: What about that empty object attr?
    // var attr: LastFMTrackSearchAttr
}
