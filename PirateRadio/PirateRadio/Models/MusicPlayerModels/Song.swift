//
//  Song.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 27.05.22.
//

import Foundation

class Song {
    var title: String = ""
    var duration: String = ""
    var localURL: URL!
    
    init(title: String, duration: String, localURL: URL) {
        self.title = title
        self.duration = duration
        self.localURL = localURL
    }
}
