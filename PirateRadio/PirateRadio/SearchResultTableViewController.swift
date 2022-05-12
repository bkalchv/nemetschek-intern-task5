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
            
            if let lastValidResponse = delegate?.lastValidResponse {
                //return self.tableView.bounds.size.height / CGFloat(lastValidResponse.pageInfo.resultsPerPage)
                return 200.00
            }
            
            return 0.0
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: SearchBarViewControllerDelegate
    
    func searchPerformedSuccessfully() {
        loadTableDataFromResponse()
        self.tableView.reloadData()
    }
    
    func loadTableDataFromResponse() {
        if let lastValidResponse = delegate?.lastValidResponse {
            tableData = lastValidResponse.items
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
        }
                
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return searchResultCellHeight
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
