//
//  SearchBarViewController.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 11.05.22.
//

import UIKit

protocol SearchBarViewControllerDelegate : AnyObject {
    func updateDataSource()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        fetcher = Fetcher.init(withViewControllerForDelegate: self)
        // initialize fetcher
    }
        
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchBarText = searchBar.text, let fetcher = fetcher {
            fetcher.cancelDataTask()
            fetcher.executeYoutubeSearchAPI(withSearchText: searchBarText)
            self.scrollTableViewToTop()
        }
    }
       
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let embeddedTableVC = segue.destination as? SearchResultTableViewController {
            print("Preparation done, delegate set")
            embeddedTableVC.delegate = self
            self.delegate = embeddedTableVC
        }
    }
}


