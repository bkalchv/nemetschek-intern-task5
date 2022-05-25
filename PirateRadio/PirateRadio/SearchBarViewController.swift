//
//  SearchBarViewController.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 11.05.22.
//

import UIKit

protocol SearchBarViewControllerDelegate : AnyObject {
    func updateDataSource()
    //func updateTableViewDataSourceDurations()
    func updateDataSourceItem(id: String, duration: String)
    func emptyTableViewDataSource()
    func scrollTableViewToTop()
}

class SearchBarViewController: UIViewController, UISearchBarDelegate, SearchResultTableViewControllerDelegate, FetcherDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    var fetcher: Fetcher? = nil
    var lastValidSearchListResponse: YouTubeSearchListResponse? {
        get {
            fetcher?.lastValidSearchListResponse
        }
    }
    weak var delegate: SearchBarViewControllerDelegate? = nil
    
    // MARK: FetcherDelegate's methods
    
    func updateTableViewDataSourceItem(id: String, duration: String) {
        self.delegate?.updateDataSourceItem(id: id, duration: duration)
    }
    
//    func updateTableViewDataSourceDurations() {
//        self.delegate?.updateTableViewDataSourceDurations()
//    }
    
    func updateTableViewDataSource() {
        self.delegate?.updateDataSource()
    }
        
    func scrollTableViewToTop() {
        self.delegate?.scrollTableViewToTop()
    }
    
    func didReachBottom() {
        let nextPageID = fetcher?.lastValidSearchListResponse?.nextPageToken
        fetcher?.executeYoutubeSearchAPI(withSearchText: searchBar.text!, nextPageID: nextPageID)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        fetcher = Fetcher.init(withViewControllerForDelegate: self)
    }
        
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchBarText = searchBar.text, let fetcher = fetcher {
            fetcher.cancelDataTask()
            self.delegate?.emptyTableViewDataSource()
            fetcher.executeYoutubeSearchAPI(withSearchText: searchBarText)
            self.scrollTableViewToTop()
        }
    }
       
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let embeddedTableVC = segue.destination as? SearchResultTableViewController {
            embeddedTableVC.delegate = self
            self.delegate = embeddedTableVC
        }
    }
}


