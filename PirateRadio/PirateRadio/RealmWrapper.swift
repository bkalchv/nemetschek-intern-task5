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
