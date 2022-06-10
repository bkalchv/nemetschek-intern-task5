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
    var imageSmallURL: String {
        get { image.first!.text }
    }
    var imageMediumURL: String {
        get { image[1].text }
    }
    var imageLargeURL: String {
        get { image[2].text }
    }
    var imageExtraLargeURL: String {
        get { image[3].text }
    }
    
    enum CodingKeys: String, CodingKey {
        case artist
        case title
        case mbid
        case url
        case image
        case attr = "@attr"
    }
}
