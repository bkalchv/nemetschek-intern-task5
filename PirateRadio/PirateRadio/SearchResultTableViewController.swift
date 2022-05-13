//
//  SearchTableViewController.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 11.05.22.
//

import UIKit

protocol SearchResultTableViewControllerDelegate: AnyObject {
    var lastValidResponse : YouTubeSearchListResponse? { get }
}

class SearchResultTableViewController: UITableViewController, SearchBarViewControllerDelegate {
      
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
            
            // download thumbnail for missing videoId
            let thumbnailFilename = "\(cellVideoID)_thumbnail.jpg"
            let thumbnailFileLocalURL = Constants.thumbnailsDirectoryURL.appendingPathComponent(thumbnailFilename)
            
            if let thumbnailData = try? Data(contentsOf: thumbnailFileLocalURL) {
                cell.thumbnailImage.image = UIImage(data: thumbnailData)
               
            } else {
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
        
            //cell.loadThumbnail(withVideoID: cellVideoID)
        }
                
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return searchResultCellHeight
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: change
        if let lastValidResponse = delegate?.lastValidResponse {
            return lastValidResponse.pageInfo.resultsPerPage
        } else {
            return 0
        }

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // based on the returned response
        return 1
    }
}
