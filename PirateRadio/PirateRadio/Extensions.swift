//
//  Extensions.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 12.05.22.
//

import AVFoundation
import Foundation

extension String {
    func unescape() -> String {
        let characters = [
            "&amp;": "&",
            "&lt;": "<",
            "&gt;": ">",
            "&quot;": "\"",
            "&apos;": "'",
            "&#39;" : "'"
        ]
        var str = self
        for (escaped, unescaped) in characters {
            str = str.replacingOccurrences(of: escaped, with: unescaped, options: NSString.CompareOptions.literal, range: nil)
        }
        return str
    }
}

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
    static let SongSelectedNotification = Notification.Name("SongSelectedNotification")
}

extension CMTime {
    var roundedSeconds: TimeInterval {
        return seconds.rounded()
    }
    var hours:  Int { return Int(roundedSeconds / 3600) }
    var minute: Int { return Int(roundedSeconds.truncatingRemainder(dividingBy: 3600) / 60) }
    var second: Int { return Int(roundedSeconds.truncatingRemainder(dividingBy: 60)) }
    var positionalTime: String {
        return hours > 0 ?
            String(format: "%d:%02d:%02d",
                   hours, minute, second) :
            String(format: "%02d:%02d",
                   minute, second)
    }
}

extension Formatter {
    static let positional: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        return formatter
    }()
}
