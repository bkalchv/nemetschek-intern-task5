//
//  YoutubeToMp3ResponseUploadedAt.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 17.05.22.
//

import Foundation

struct YoutubeToMp3ResponseUploadedAt : Codable {
    var date: String
    var timezone_type: Int
    var timezone: String
}
