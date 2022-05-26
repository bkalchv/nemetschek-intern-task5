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
    static let DurationsReceivedNotification = Notification.Name("DurationsReceivedNotification")
    static let PlayVideoNotification = Notification.Name("PlayVideoNotification")
    static let PirateModeRequirementsFulfilledNotification = Notification.Name("PirateModeRequirementsFulfilledNotification")
}

extension Formatter {
    static let positional: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        return formatter
    }()
}
