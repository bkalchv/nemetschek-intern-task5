//
//  RealmWrapper.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 8.06.22.
//

import Foundation
import RealmSwift

class RealmWrapper {
    public static func addSong(_ song: Song) {
        if let realm = try? Realm() {
            try? realm.write({
                realm.add(song)
            })
        }
    }
    
    public static func truncateSongsTable() {
        if let realm = try? Realm() {
            try? realm.write({
                let allSongs = realm.objects(Song.self)
                realm.delete(allSongs)
            })
        }
    }
    
    public static func updateAlbumsProperties(songName: String, songArtist: String?, albumName: String, albumArtworkFilename: String) {
        if let realm = try? Realm(),
           let song = realm.objects(Song.self).first(where: { $0.title == songName && $0.artist == songArtist }) {
            try? realm.write({
                song.album = albumName
                song.albumArtworkFilename = albumArtworkFilename
                realm.add(song, update: .modified)
            })
        }
    }
    
    public static func allDownloadedSongs() -> Results<Song>? {
        do {
            let realm = try Realm()
            return realm.objects(Song.self)
        } catch {
            print("REALM ERROR: \(error)")
            return nil
        }
    }
}
