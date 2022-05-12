//
//  Extensions.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 12.05.22.
//

import Foundation

extension URL {
    var isDirectory: Bool {
       (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
}

extension Notification.Name {
    static let ThumbnailDownloadedNotification = Notification.Name("ThumbnailDownloadedNotification")
}
