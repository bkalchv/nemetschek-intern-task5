//
//  SearchTableViewController.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 11.05.22.
//

import UIKit

protocol SearchResultTableViewControllerDelegate: AnyObject {
    var lastValidSearchListResponse: YouTubeSearchListResponse? { get }
    func didReachBottom()
}

class SearchResultTableViewController: UITableViewController, SearchBarViewControllerDelegate, SearchResultCellDelegate {
    var indexPaths: [String:IndexPath] = [:]
    weak var delegate: SearchResultTableViewControllerDelegate?
    var tableData: [YouTubeSearchResultItem] = []
    var searchResultCellHeight : CGFloat {
        get {
            if delegate?.lastValidSearchListResponse != nil {
                
                switch UIDevice.current.orientation {
                case .portrait:
                    return 280.00
                case .landscapeLeft:
                    return 230.00
                case .landscapeRight:
                    return 230.00
                default:
                    return 280.00
                }
                
            }
            return 0.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishThumbnailDownload(notification:)), name: .ThumbnailDownloadedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveDurations(notification:)), name: .DurationsReceivedNotification, object: nil)
    }
    
    private func accumulateIndexPaths(ofVideoIds videoIds: [String]) -> [IndexPath] {
        var accumulatedIndexPaths: [IndexPath] = []
        for videoId in videoIds {
            if let currentIndexPath = indexPaths[videoId] {
                accumulatedIndexPaths.append(currentIndexPath)
            }
        }
        return accumulatedIndexPaths
    }
    
    @objc func didReceiveDurations(notification: Notification) {
        if let videoIds = notification.userInfo?["videoIds"] as? [String] {
            let accumulatedIndexPaths = accumulateIndexPaths(ofVideoIds: videoIds)
            if !accumulatedIndexPaths.isEmpty {
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: accumulatedIndexPaths, with: .automatic)
                }
            }
        }
    }
    
    @objc func didFinishThumbnailDownload(notification: Notification) {
        if let indexPath = notification.userInfo?["indexPath"] as? IndexPath {
            NSLog("Notified to reload \(indexPath.row)'s item")
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func scrollTableViewToTop() {
        self.tableView.setContentOffset(CGPoint.zero, animated:true)
    }
    
    // MARK: SearchBarViewControllerDelegate
    
    func updateDataSource() {
        loadTableDataFromResponse()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func updateDataSourceItem(id: String, duration: String) {
        if !tableData.isEmpty, let itemIndexPath = indexPaths[id] {
            let item = tableData[itemIndexPath.row]
            item.duration = duration
        }
    }
        
    func emptyTableViewDataSource() {
        if !self.tableData.isEmpty { self.tableData = [] }
    }
    
    func emptyTableViewIndexPaths() {
        indexPaths.removeAll()
    }
    
    func loadTableDataFromResponse() {
        if let lastValidResponse = delegate?.lastValidSearchListResponse {
            tableData += lastValidResponse.items
        }
    }
    
    private func extractDateFromPublishTime(publishTime: String) -> String {
        
        if let upperBound = publishTime.firstIndex(of: "T") {
            return String(publishTime[publishTime.startIndex..<upperBound])
        }
        
        return ""
    }
    
    private func formatDurationFromIso8601String(ISO8601Duration: String) -> String {
        var duration = ISO8601Duration
        
        if duration.hasPrefix("PT") { duration.removeFirst(2) }
        
        let hour, minute, second: Double
        if let index = duration.firstIndex(of: "H") {
            hour = Double(duration[..<index]) ?? 0
            duration.removeSubrange(...index)
        } else { hour = 0 }
        if let index = duration.firstIndex(of: "M") {
            minute = Double(duration[..<index]) ?? 0
            duration.removeSubrange(...index)
        } else { minute = 0 }
        if let index = duration.firstIndex(of: "S") {
            second = Double(duration[..<index]) ?? 0
        } else { second = 0 }
        return Formatter.positional.string(from: hour * 3600 + minute * 60 + second) ?? "0:00"
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = tableData.count - 1
        if indexPath.row == lastElement {
            // handle your logic here to get more items, add it to dataSource and reload tableview
            print("Reached bottom")
            self.delegate?.didReachBottom()
        }
    }
    
    private func createThumbnailsDirectoryInCacheIfNonExistent() {
        let thumbnailsDirectoryURL = Constants.THUMBNAILS_DIRECTORY_URL
        
        if !thumbnailsDirectoryURL.isDirectory {
            do {
                try FileManager.default.createDirectory(at: thumbnailsDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: TableView DataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
        
        if !tableData.isEmpty && indexPath.row < tableData.count {
            let searchResultItem = tableData[indexPath.row]
            
            let cellVideoID = searchResultItem.id.videoId
            let cellTitle = searchResultItem.snippet.title
            let cellPublishTime = searchResultItem.snippet.publishTime
            let cellChannel = searchResultItem.snippet.channelTitle
            
            if let cellVideoDuration = searchResultItem.duration {
                cell.durationLabel.text = formatDurationFromIso8601String(ISO8601Duration: cellVideoDuration)
            }
            
            cell.videoId = cellVideoID
            cell.titleLabel.text = cellTitle
            cell.publishTimeLabel.text = extractDateFromPublishTime(publishTime: cellPublishTime)
            cell.channelLabel.text = cellChannel
            cell.delegate = self
            
            // download thumbnail for missing videoId
            let thumbnailFilename = "\(cellVideoID)_thumbnail.jpg"
            let thumbnailFileLocalURL = Constants.THUMBNAILS_DIRECTORY_URL.appendingPathComponent(thumbnailFilename)
            
            if let thumbnailData = try? Data(contentsOf: thumbnailFileLocalURL) {
                cell.thumbnailImage.image = UIImage(data: thumbnailData)
               
            } else {
                
                self.createThumbnailsDirectoryInCacheIfNonExistent()
                
                // download the thumbnail
                let thumbnailURL = URL(string: searchResultItem.snippet.thumbnails.medium.url)!
                
                let thumbnailDownloadTask = URLSession.shared.downloadTask(with: thumbnailURL) {
                    url, response, error in
                    
                    guard let temporaryFileURL = url else { return }
                    do {
                        print("\(thumbnailFileLocalURL) downloaded.")
                        try FileManager.default.moveItem(at: temporaryFileURL, to: thumbnailFileLocalURL)
                        
                        NotificationCenter.default.post(name: .ThumbnailDownloadedNotification, object: nil, userInfo: ["indexPath" : indexPath])
                    } catch {
                        print ("file error: \(error)")
                    }
                }
                thumbnailDownloadTask.resume()
                
            }
        }
         
        indexPaths[cell.videoId] = indexPath
        
        return cell
    }
    
    func presentVideoPlayerVC(videoId: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let videoPlayerVC = storyboard.instantiateViewController(withIdentifier: "VideoPlayerVC") as! VideoPlayerViewController
        videoPlayerVC.videoId = videoId
        videoPlayerVC.title = "Video Player"
        self.navigationController?.pushViewController(videoPlayerVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedSearchResultIndex = indexPath.row
        let selectedSearchResult: YouTubeSearchResultItem = self.tableData[selectedSearchResultIndex]
        let selectedSearchResultVideoID = selectedSearchResult.id.videoId
        
       presentVideoPlayerVC(videoId: selectedSearchResultVideoID)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return searchResultCellHeight
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: change
        if let _ = delegate?.lastValidSearchListResponse {
            return tableData.count
        }
        
        return 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // based on the returned response
        return 1
    }
}
