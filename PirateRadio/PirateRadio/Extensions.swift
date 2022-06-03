//
//  Extensions.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 12.05.22.
//

import AVFoundation
import Foundation

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date)) years ago"   }
        if months(from: date)  > 0 { return "\(months(from: date)) months ago"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date)) weeks ago"   }
        if days(from: date)    > 0 { return "\(days(from: date)) days ago"    }
        if hours(from: date)   > 0 { return "\(hours(from: date)) hours ago"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date)) months ago" }
        if seconds(from: date) > 0 { return "\(seconds(from: date)) seconds ago" }
        return ""
    }
}


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
    static let DownloadedSongsVCTableDataUpdated = Notification.Name("DownloadedSongsVCTableDataUpdated")
    static let DidFinishDownloadingMP3File = Notification.Name("DidFinishDownloadingMP3File")
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
