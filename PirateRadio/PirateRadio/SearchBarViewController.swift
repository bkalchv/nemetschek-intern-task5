//
//  SearchBarViewController.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 11.05.22.
//

import UIKit

protocol SearchBarViewControllerDelegate : AnyObject {
    func searchPerformedSuccessfully()
}

class SearchBarViewController: UIViewController, UISearchBarDelegate, SearchResultTableViewControllerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var dataTask: URLSessionDataTask? = nil
    var lastValidResponse : YouTubeSearchListResponse? = nil
    weak var delegate : SearchBarViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        dataTask?.cancel()
        
        if let searchBarText = searchBar.text, var urlComponents = URLComponents(string: "https://www.googleapis.com/youtube/v3/search")  {
            
            urlComponents.query = "part=snippet&order=viewCount&q=\(searchBarText)&type=video&key=\(Constants.API_KEY)"
            
            guard let youtubeApiURL = urlComponents.url else { return }
            
            let session = URLSession.shared
            
            var request = URLRequest(url: youtubeApiURL)
            request.setValue("servicecontrol.googleapis.com/net.nemetschek.PirateRadio", forHTTPHeaderField: "x-ios-bundle-identifier")
            request.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 15_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Mobile/15E148 Safari/604.1", forHTTPHeaderField: "User-Agent")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            dataTask = session.dataTask(with: request) { [weak self] data, response, error in
                defer {
                    self?.dataTask = nil
                }
                
                print("Response code = \((response as! HTTPURLResponse).statusCode)")
                if let error = error {
                    // TODO: Handle error
                    print("DataTask error: " + error.localizedDescription)
                } else if let data = data,
                          let response = response as? HTTPURLResponse,
                          response.statusCode == 200 { // Successful response
                    
                    if let JSONString = String(data: data, encoding: String.Encoding.utf8) {
                        print(JSONString)
                        
                        let responseData = Data(JSONString.utf8)
                        
                        let JSONDecoder = JSONDecoder()
                        JSONDecoder.keyDecodingStrategy = .convertFromSnakeCase
                        
                        do {
                            let decodedSearchListResponse = try JSONDecoder.decode(YouTubeSearchListResponse.self, from: responseData)
                            
                            self?.lastValidResponse = decodedSearchListResponse
                            
                        } catch {
                            print("Error: \(error.localizedDescription)")
                            print(error)
                        }
                        
                        print("Server response succesfully decoded to model.")
                        
                        DispatchQueue.main.async {
                            self?.delegate?.searchPerformedSuccessfully()
                        }
                    }
                }
            }
            
            dataTask?.resume()
            print("DataTask started")
            
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


