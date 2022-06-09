//
//  TrackGetInfoResponseTrack.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 9.06.22.
//

import Foundation

class TrackGetInfoResponseTrack: Codable {
    var name: String
    var mbid: String
    var url: String
    var duration: String
    var stramable: TrackGetInfoStreamable
    var listeners: String
    var playcount: String
    var artist: TrackGetInfoArtist
    var album: TrackGetInfoAlbum
    var toptags: TrackGetInfoTopTags
    var wiki: TrackGetInfoWiki
}
