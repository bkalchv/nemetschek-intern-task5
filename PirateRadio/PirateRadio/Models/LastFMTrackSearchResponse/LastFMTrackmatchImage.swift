//
//  LastFMTrackmatchImage.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 8.06.22.
//

import Foundation

class LastFMTrackmatchImage: Codable {
    var text: String
    var size: String

    enum CodingKeys: String, CodingKey {
        case text = "#text"
        case size
    }
}
