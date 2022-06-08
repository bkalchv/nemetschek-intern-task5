//
//  LastFMTrackmatch.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 8.06.22.
//

import Foundation

class LastFMTrackmatch: Codable {
    var name: String
    var artist: String
    var url: String
    var streamable: String
    var listeners: String
    var image: [LastFMTrackmatchImage]
    var mbid: String
}
