//
//  Song.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 27.05.22.
//

import Foundation

class Song {
    var title: String = ""
    var artist: String = "Unknown"
    var duration: String = ""
    var localURL: URL!
    
    // add album: String
    // add artwork: URL
    // TODO: edit artist, title etc
    // TODO: add artowrk for album
    // if no artwork found -> show thumbnail
    
    init(title: String, artist: String, duration: String, localURL: URL) {
        self.title = title
        self.artist = artist
        self.duration = duration
        self.localURL = localURL
    }
    
    static func ==(lhs: Song, rhs: Song) -> Bool {
        return  lhs.title == rhs.title &&
                lhs.artist == rhs.artist &&
                lhs.duration == rhs.duration &&
                lhs.localURL == rhs.localURL
    }
}
