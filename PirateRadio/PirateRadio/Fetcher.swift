//
//  Fetcher.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 13.05.22.
//

import UIKit

protocol FetcherDelegate : AnyObject {
    func updateTableViewDataSource()
    func performPreloadedThumbnailsSearch()
    func scrollTableViewToTop()
}

class Fetcher {
    
    var lastValidResponse: YouTubeSearchListResponse? = nil
    var dataTask: URLSessionDataTask? = nil
    weak var delegate : FetcherDelegate? = nil
    
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
    
    private func downloadMissingThumbnails() {
        
        let zippedItemsToIndices = zip(lastValidResponse!.items, (0...lastValidResponse!.items.count))
        
        for zippedItem in zippedItemsToIndices {
            
            let currentSearchItem = zippedItem.0
            let currentIndex = zippedItem.1
            
            let currentSearchItemVideoID = currentSearchItem.id.videoId
            let thumbnailFilename = "\(currentSearchItemVideoID)_thumbnail.jpg"
            let thumbnailFileLocalURL = Constants.thumbnailsDirectoryURL.appendingPathComponent(thumbnailFilename)
            
            // TODO: Ask if not reassurance
            if !FileManager.default.fileExists(atPath: thumbnailFileLocalURL.path) {
                
                let thumbnailURL = URL(string: currentSearchItem.snippet.thumbnails.medium.url)
                let thumbnailDownloadTask = URLSession.shared.downloadTask(with: thumbnailURL!) {
                    url, response, error in
                    
                    guard let temporaryFileURL = url else { return }
                    do {
                        print("\(thumbnailFileLocalURL) downloaded.")
                        try FileManager.default.moveItem(at: temporaryFileURL, to: thumbnailFileLocalURL)
                        // TODO:
                        NotificationCenter.default.post(name: .ThumbnailDownloadedNotification, object: nil, userInfo: ["indexPath" : IndexPath(row: currentIndex, section: 0)])
                    } catch {
                        print ("file error: \(error)")
                    }
                }
                thumbnailDownloadTask.resume()
            }
        }
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
    
    private func initializeYoutubeSearchAPIURL(withSearchText searchText: String) -> URL? {
        var youtubeSearchAPIURL = URLComponents(string: Constants.youtubeSearchAPIAsString)!
        
        youtubeSearchAPIURL.query = "part=snippet&order=viewCount&q=\(searchText)&type=video&key=\(API_KEY.value)"
        
        return youtubeSearchAPIURL.url
    }
    
    private func initializeURLRequest(withSearchText searchText: String) -> URLRequest? {
        
        guard let youtubeApiURL = initializeYoutubeSearchAPIURL(withSearchText: searchText) else { return nil }
        
        var request = URLRequest(url: youtubeApiURL)
        
        request.setValue("servicecontrol.googleapis.com/net.nemetschek.PirateRadio", forHTTPHeaderField: "x-ios-bundle-identifier")
        request.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 15_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Mobile/15E148 Safari/604.1", forHTTPHeaderField: "User-Agent")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    public func executeYoutubeSearchAPI(withSearchText searchText: String) {
        
        if let request = initializeURLRequest(withSearchText: searchText) {
            
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
                        
                        if let areAllThumbnailFilesPresent = self?.areAllThumbnailFilesPresent(),
                           areAllThumbnailFilesPresent {
                            print("Thumbnails already exist in Cache.")
                            DispatchQueue.main.async {
                                self?.delegate?.performPreloadedThumbnailsSearch()
                            }
                        } else {
                            if self?.lastValidResponse != nil {
                                self?.createThumbnailsDirectoryInCacheIfNonExistent()
                                self?.downloadMissingThumbnails()
                                //TODO: Ask if fine
                                DispatchQueue.main.async {
                                    self?.delegate?.scrollTableViewToTop()
                                }
                            }
                        }
                    }
                } else if let response = response as? HTTPURLResponse, response.statusCode == 403 {
                    self?.updateLastValidResponse(forJSONString: Constants.mockResultJSONString)
                    self?.delegate?.updateTableViewDataSource()
                    if let areAllThumbnailFilesPresent = self?.areAllThumbnailFilesPresent(),
                       areAllThumbnailFilesPresent {
                        print("Thumbnails already exist in Cache.")
                        DispatchQueue.main.async {
                            self?.delegate?.performPreloadedThumbnailsSearch()
                        }
                    } else {
                        if self?.lastValidResponse != nil {
                            self?.createThumbnailsDirectoryInCacheIfNonExistent()
                            self?.downloadMissingThumbnails()
                            //TODO: Ask if fine
                            DispatchQueue.main.async {
                                self?.delegate?.scrollTableViewToTop()
                            }
                        }
                    }
                }
            }
            
            dataTask?.resume()
            print("DataTask started")
        }
        
        
    }
}
