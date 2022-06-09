//
//  TrackGetInfoAlbum.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 9.06.22.
//

import Foundation

class TrackGetInfoAlbum: Codable {
    var artist: String
    var title: String
    var mbid: String
    var url: String
    var image: [TrackGetInfoAlbumImage]
    var attr: TrackGetInfoAlbumAttr
    
    enum CodingKeys: String, CodingKey {
        case artist
        case title
        case mbid
        case url
        case image
        case attr = "@attr"
    }
}
