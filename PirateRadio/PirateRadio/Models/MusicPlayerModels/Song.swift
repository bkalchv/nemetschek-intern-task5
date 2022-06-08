//
//  Song.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 27.05.22.
//

import Foundation
import RealmSwift

class Song: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String = ""
    @Persisted var artist: String = "Unknown"
    @Persisted var duration: String = ""
    @Persisted var filename: String = ""
    
    // add album: String
    // add artwork: URL
    // TODO: edit artist, title etc
    // TODO: add artowrk for album
    // if no artwork found -> show thumbnail
    
    static func create(title: String, artist: String, duration: String, filename: String) -> Song {
        let song = Song()
        song.title = title
        song.artist = artist
        song.duration = duration
        song.filename = filename
        return song
    }
    
//    init(title: String, artist: String, duration: String, localURL: URL) {
//        self.title = title
//        self.artist = artist
//        self.duration = duration
//        self.localURL = localURL
//    }
    
//    init(title: String, artist: String, duration: String, localPath: String) {
//        self.title = title
//        self.artist = artist
//        self.duration = duration
//        self.localPath = localPath
//    }
    
    static func ==(lhs: Song, rhs: Song) -> Bool {
        return  lhs._id == rhs._id &&
                lhs.title == rhs.title &&
                lhs.artist == rhs.artist &&
                lhs.duration == rhs.duration &&
                lhs.filename == rhs.filename
    }
}
