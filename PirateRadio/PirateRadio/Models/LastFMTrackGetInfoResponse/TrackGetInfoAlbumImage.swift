//
//  TrackGetInfoAlbumImage.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 9.06.22.
//

import Foundation

class TrackGetInfoAlbumImage: Codable {
    var text: String
    var size: String
    
    enum CodingKeys: String, CodingKey {
        case text = "#text"
        case size
    }
}
