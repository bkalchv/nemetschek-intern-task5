//
//  TraclGetInfoStreamable.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 9.06.22.
//

import Foundation

class TrackGetInfoStreamable: Codable {
    var text: String
    var fulltrack: String
    
    enum CodingKeys: String, CodingKey {
        case text = "#text"
        case fulltrack
    }
}
