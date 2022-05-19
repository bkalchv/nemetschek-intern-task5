//
//  SearchBarViewController.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 11.05.22.
//

import UIKit

protocol SearchBarViewControllerDelegate : AnyObject {
    func updateDataSource()
    func emptyTableViewDataSource()
    func scrollTableViewToTop()
}

class SearchBarViewController: UIViewController, UISearchBarDelegate, SearchResultTableViewControllerDelegate, FetcherDelegate {
    
    // MARK: FetcherDelegate's methods
    
    func updateTableViewDataSource() {
        self.delegate?.updateDataSource()
    }
        
    func scrollTableViewToTop() {
        self.delegate?.scrollTableViewToTop()
    }
    
    @IBOutlet weak var searchBar: UISearchBar!

    var fetcher : Fetcher? = nil
    var lastValidResponse: YouTubeSearchListResponse? {
        get {
            fetcher?.lastValidResponse
        }
    }
    weak var delegate : SearchBarViewControllerDelegate? = nil
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print("Orientation changed")
    }
    
    func didReachBottom() {
        let nextPageID = fetcher?.lastValidResponse?.nextPageToken
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


