//
//  Constants.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 11.05.22.
//

import Foundation

struct Constants {
    private static let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
    static let cachesDirectoryURL = cachesDirectory[0]
    
    static let thumbnailsDirectoryURL = Constants.cachesDirectoryURL.appendingPathComponent("Thumbnails")
}
