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
    
    static private func extractFilenameFromUrl(url: URL) -> String {
        return url.deletingPathExtension().lastPathComponent
    }
    
    static public func downloadedSongsSortedByDateOfCreation() -> [Song] {
        if let downloadedMP3FilesURLs = downloadedMP3FilesURLsSortedByDescendingDateOfCreation() {
            var downloadedSongs: [Song] = []
            for fileURL in downloadedMP3FilesURLs {
                let title = extractFilenameFromUrl(url: fileURL)
                let audioAsset = AVAsset(url: fileURL)
                let duration = audioAsset.duration.positionalTime
                downloadedSongs.append(Song(title: title, duration: duration, localURL: fileURL))
            }
            return downloadedSongs
        }
        
        return []
    }
}
