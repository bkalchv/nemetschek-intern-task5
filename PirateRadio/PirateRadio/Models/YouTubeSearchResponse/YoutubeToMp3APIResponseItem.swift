//
//  YoutubeToMp3APIResponseItem.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 17.05.22.
//

import Foundation

struct YoutubeToMp3Response : Codable {
    var error: Bool
    var youtube_id: String
    var title: String
    var alt_title: String?
    var duration: Int
    var file: String
    var uploaded_at: YoutubeToMp3ResponseUploadedAt
}
