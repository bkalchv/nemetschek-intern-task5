//
//  Playlist.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 3.06.22.
//

import Foundation
import RealmSwift

class Playlist: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String = ""
    @Persisted var songs: List<Song> = List<Song>()

    static func create(name: String, songs: [Song]) -> Playlist {
        let playlist = Playlist()
        playlist.name = name
        playlist.songs.append(objectsIn: songs)
        
        return playlist
    }
}
