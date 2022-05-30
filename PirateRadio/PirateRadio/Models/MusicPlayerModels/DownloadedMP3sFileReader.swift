//
//  DownloadedMP3sReader.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 27.05.22.
//

import AVFoundation
import Foundation

class DownloadedMP3sFileReader {
    
    static private func diractoryExistsAtPath(_ path: String) -> Bool {
        var isDirectory: ObjCBool = true
        let exists = FileManager.default.fileExists(atPath: Constants.YOUTUBE_TO_MP3_DOWNLOADS_DIRECTORY_URL.path, isDirectory: &isDirectory)
        
        return exists && isDirectory.boolValue
    }
    
    static private func downloadedMP3FilesURLsSortedByDescendingDateOfCreation() -> [URL]? {
        print(Constants.YOUTUBE_TO_MP3_DOWNLOADS_DIRECTORY_URL.absoluteString)
        if !diractoryExistsAtPath(Constants.YOUTUBE_TO_MP3_DOWNLOADS_DIRECTORY_URL.absoluteString) {
            return nil
        }
        
        var MP3FilesURLs: [URL] = []
        
        do {
            let MP3DownloadsDirectoryContents: [URL] = try FileManager.default.contentsOfDirectory(at: Constants.YOUTUBE_TO_MP3_DOWNLOADS_DIRECTORY_URL, includingPropertiesForKeys: [.creationDateKey] , options: [.skipsHiddenFiles])
            
            for fileURL in MP3DownloadsDirectoryContents {
                if fileURL.pathExtension == "mp3" {
                    MP3FilesURLs.append(fileURL)
                }
            }
            
            return MP3FilesURLs.map { url in
                (url, (try? url.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast)
            }
            .sorted(by: {$0.1 > $1.1 })
            .map({ $0.0 })
                       
                    } catch {
            print(error)
            return nil
        }
    }
    
    static private func extractFilenameFromURL(url: URL) -> String {
        return url.deletingPathExtension().lastPathComponent
    }
    
    static private func extractArtistFromFilename(filename: String) -> String {
        let delimiter = "-"
        if filename.contains(delimiter) {
            let artistName = filename.components(separatedBy: delimiter).first ?? Constants.SONG_DEFAULT_ARTIST_VALUE
            return artistName.trimmingCharacters(in: .whitespaces)
        } else {
            return Constants.SONG_DEFAULT_ARTIST_VALUE
        }
    }
    
    static private func extractTitleFromFilename(filename: String) -> String {
        let delimiter: Character = "-"
        if let delimiterFirstAppearance = filename.firstIndex(of: delimiter) {
            
            let title = String(filename[filename.index(after: delimiterFirstAppearance)...])
            return title.trimmingCharacters(in: .whitespaces)
        } else {
            return filename
        }
    }

    
    static public func downloadedSongsSortedByDateOfCreation() -> [Song] {
        guard let downloadedMP3FilesURLs = downloadedMP3FilesURLsSortedByDescendingDateOfCreation() else { return [] }
        
        return downloadedMP3FilesURLs.map { fileURL in
            let filename = extractFilenameFromURL(url: fileURL)
            let title = extractTitleFromFilename(filename: filename)
            let artist = extractArtistFromFilename(filename: filename)
            let audioAsset = AVAsset(url: fileURL)
            let duration = audioAsset.duration.positionalTime
            
            return Song(title: title, artist: artist, duration: duration, localURL: fileURL)
        }
    }
}
