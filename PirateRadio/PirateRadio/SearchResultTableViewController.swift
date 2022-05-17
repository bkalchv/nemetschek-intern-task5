//
//  SearchTableViewController.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 11.05.22.
//

import UIKit

protocol SearchResultTableViewControllerDelegate: AnyObject {
    var lastValidResponse : YouTubeSearchListResponse? { get }
    func didReachBottom()
}

class SearchResultTableViewController: UITableViewController, SearchBarViewControllerDelegate, SearchResultCellDelegate {
      
    weak var delegate : SearchResultTableViewControllerDelegate?
    var tableData : [YouTubeSearchResultItem] = []
    var searchResultCellHeight : CGFloat {
        get {
            
            if (delegate?.lastValidResponse) != nil {
                return 260.00
            }
            
            return 0.0
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         NotificationCenter.default.addObserver(self, selector: #selector(didFinishThumbnailDownload(notification:)), name: .ThumbnailDownloadedNotification, object: nil)
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
    
    func emptyTableViewDataSource() {
        if !self.tableData.isEmpty { self.tableData = [] }
    }
    
    func loadTableDataFromResponse() {
        if let lastValidResponse = delegate?.lastValidResponse {
            tableData += lastValidResponse.items
        }
    }
    
    func extractDateFromPublishTime(publishTime: String) -> String {
        
        if let upperBound = publishTime.firstIndex(of: "T") {
            return String(publishTime[publishTime.startIndex..<upperBound])
        }
        
        return ""
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
        let thumbnailsDirectoryURL = Constants.thumbnailsDirectoryURL
        
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
            
            
            cell.videoIDLabel.text = cellVideoID
            cell.titleLabel.text = cellTitle
            cell.publishTimeLabel.text = extractDateFromPublishTime(publishTime: cellPublishTime)
            cell.delegate = self
            
            // download thumbnail for missing videoId
            let thumbnailFilename = "\(cellVideoID)_thumbnail.jpg"
            let thumbnailFileLocalURL = Constants.thumbnailsDirectoryURL.appendingPathComponent(thumbnailFilename)
            
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
                        // TODO:
                        NotificationCenter.default.post(name: .ThumbnailDownloadedNotification, object: nil, userInfo: ["indexPath" : indexPath])
                    } catch {
                        print ("file error: \(error)")
                    }
                }
                thumbnailDownloadTask.resume()
                
            }
        }
                
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
        if let _ = delegate?.lastValidResponse {
            return tableData.count
        }
        
        return 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // based on the returned response
        return 1
    }
}
