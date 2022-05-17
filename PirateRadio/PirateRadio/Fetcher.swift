//
//  Fetcher.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 13.05.22.
//

import UIKit

protocol FetcherDelegate : AnyObject {
    func updateTableViewDataSource()
}

class Fetcher {
    
    var lastValidResponse: YouTubeSearchListResponse? = nil
    var dataTask: URLSessionDataTask? = nil
    weak var delegate : FetcherDelegate? = nil
    
    var mockResponses = [Constants.mockResultJSONString, Constants.mockResultNextPageJSON]
    
    init?(withViewControllerForDelegate vcForDelegate : SearchBarViewController) {
        self.delegate = vcForDelegate
    }
    
    public func cancelDataTask() {
        dataTask?.cancel()
    }
    
    private func areAllThumbnailFilesPresent() -> Bool {
        for searchItem in lastValidResponse!.items {
            let searchItemVideoID = searchItem.id.videoId
            let thumbnailFilename = "\(searchItemVideoID)_thumbnail.jpg"
            let thumbnailFileLocalURL = Constants.thumbnailsDirectoryURL.appendingPathComponent(thumbnailFilename)
            
            if !FileManager.default.fileExists(atPath: thumbnailFileLocalURL.path) {
                return false
            }
        }
        
        return true
    }
        
    private func updateLastValidResponse(forJSONString JSONString: String) {
        let responseData = Data(JSONString.utf8)
        
        let JSONDecoder = JSONDecoder()
        JSONDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let decodedSearchListResponse = try JSONDecoder.decode(YouTubeSearchListResponse.self, from: responseData)
            self.lastValidResponse = decodedSearchListResponse
            
        } catch {
            print("Error: \(error.localizedDescription)")
            print(error)
        }
        
        print("Server response succesfully fetched to models.")
    }
    
    private func initializeYoutubeSearchAPIURL(withSearchText searchText: String, nextPageID: String? = nil) -> URL? {
        var youtubeSearchAPIURL = URLComponents(string: Constants.youtubeSearchAPIAsString)!
        var queryItems = [
            URLQueryItem(name: "part", value: "snippet"),
            URLQueryItem(name: "order", value: "viewCount"),
            URLQueryItem(name: "q", value: searchText),
            URLQueryItem(name: "type", value: "video"),
            URLQueryItem(name: "key", value: API_KEY.value)
        ]
        
        if let nextPageID = nextPageID {
            queryItems.append(URLQueryItem(name: "pageToken", value: nextPageID))
        }
        
        youtubeSearchAPIURL.queryItems = queryItems
        
        return youtubeSearchAPIURL.url
    }
    
    private func initializeURLRequest(withSearchText searchText: String, nextPageID: String? = nil) -> URLRequest? {
        
        guard let youtubeApiURL = initializeYoutubeSearchAPIURL(withSearchText: searchText, nextPageID: nextPageID) else { return nil }
        
        var request = URLRequest(url: youtubeApiURL)
        
        request.setValue(Constants.IOS_BUNDLE_IDENTIFIER_HEADER, forHTTPHeaderField: Constants.IOS_BUNDLE_IDENTIFIER_HEADER_FIELD)
        request.setValue(Constants.USER_AGENT, forHTTPHeaderField: Constants.USER_AGENT_FIELD)
        request.setValue(Constants.CONTENT_TYPE, forHTTPHeaderField: Constants.CONTENT_TYPE_FIELD)
        
        return request
    }
    
    public func executeYoutubeSearchAPI(withSearchText searchText: String, nextPageID: String? = nil) {
        
        if let request = initializeURLRequest(withSearchText: searchText, nextPageID: nextPageID) {
            
            dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
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
                        //print(JSONString)
                        self?.updateLastValidResponse(forJSONString: JSONString)
                        self?.delegate?.updateTableViewDataSource()
                    }
                } else if let response = response as? HTTPURLResponse, response.statusCode == 403 {
                    self?.updateLastValidResponse(forJSONString: self?.mockResponses.first ?? "")
                    self?.delegate?.updateTableViewDataSource()
                    
                    if !(self?.mockResponses.isEmpty ?? true) {
                        self?.mockResponses.removeFirst()
                    } else {
                        print("No more mock responses")
                    }
                }
            }
            
            dataTask?.resume()
            print("DataTask started")
        }
        
        
    }
}
