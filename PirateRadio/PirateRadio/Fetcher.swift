//
//  Fetcher.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 13.05.22.
//

import UIKit

protocol FetcherDelegate : AnyObject {
    func updateTableViewDataSource()
    func updateTableViewDataSourceItem(id: String, duration: String)
}

class Fetcher {
    
    var lastValidSearchListResponse: YouTubeSearchListResponse? = nil
    var dataTask: URLSessionDataTask? = nil
    weak var delegate : FetcherDelegate? = nil
    
    var mockResponses = [Constants.MOCK_RESULT_JSON_STRING, Constants.MOCK_RESULT_NEXT_PAGE_JSON_STRING]
    
    init?(withViewControllerForDelegate vcForDelegate : SearchBarViewController) {
        self.delegate = vcForDelegate
    }
    
    public func cancelDataTask() {
        dataTask?.cancel()
    }
    
    private func initializeYouTubeVideoListAPI(videoIds: [String]) -> URL? {
        var youTubeVideoListAPIURL = URLComponents(string: Constants.YOUTUBE_VIDEOS_API_URL)!
        let queryItems = [
            URLQueryItem(name: "part", value: "contentDetails"),
            URLQueryItem(name: "id", value: videoIds.joined(separator: ",")),
            URLQueryItem(name: "key", value: API_KEY.value)
        ]
        
        youTubeVideoListAPIURL.queryItems = queryItems
        
        return youTubeVideoListAPIURL.url
    }
    
    private func initializeURLRequest(videoIds: [String]) -> URLRequest? {
        
        guard let youTubeVideosListAPIURL = initializeYouTubeVideoListAPI(videoIds: videoIds) else { return nil}
        
        print(youTubeVideosListAPIURL.absoluteString)
        
        var request = URLRequest(url: youTubeVideosListAPIURL)
        
        setRequestDefaultValues(request: &request)
        
        return request
    }
    
    private func setRequestDefaultValues(request: inout URLRequest) {
        request.setValue(Constants.IOS_BUNDLE_IDENTIFIER_HEADER, forHTTPHeaderField: Constants.IOS_BUNDLE_IDENTIFIER_HEADER_FIELD)
        request.setValue(Constants.USER_AGENT, forHTTPHeaderField: Constants.USER_AGENT_FIELD)
        request.setValue(Constants.CONTENT_TYPE, forHTTPHeaderField: Constants.CONTENT_TYPE_FIELD)
    }
    
    public func executeYoutubeVideoListAPI(videoIds: [String], completion: @escaping ([String]) -> Void) {
        
        if let request = initializeYouTubeVideoListAPI(videoIds: videoIds) {
            
            dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                defer {
                    self?.dataTask = nil
                }
                
                print("Response code = \((response as! HTTPURLResponse).statusCode)")
                if let error = error {
                    // TODO: Handle error
                    // TODO: Call completion
                    print("DataTask error: " + error.localizedDescription)
                } else if let data = data,
                          let response = response as? HTTPURLResponse,
                          response.statusCode == 200 { // Successful response
                    
                    if let JSONString = String(data: data, encoding: String.Encoding.utf8) {
                        print(JSONString)
                        if let fetchedResponse = self?.videoListResponse(forJSONString: JSONString), !fetchedResponse.items.isEmpty {
                            let durations = fetchedResponse.items.map { $0.contentDetails.duration }
                            completion(durations)
                        }
                    }
                } else if let response = response as? HTTPURLResponse, response.statusCode == 403 {
                    print("HELLO: Make a mock response, please!")
                                    
                    if let fetchedResponse = self?.videoListResponse(forJSONString: Constants.MOCK_RESULT_VIDEO_LIST_RESULT_JSON_STRING), !fetchedResponse.items.isEmpty {
                        let durations = fetchedResponse.items.map { $0.contentDetails.duration }
                        completion(durations)
                    }
                }
            }
            
            dataTask?.resume()
            print("DataTask started")
        }
    }
    
    private func videoListResponse(forJSONString JSONString: String) -> YouTubeVideoListResponse? {
        let responseData = Data(JSONString.utf8)
        
        let JSONDecoder = JSONDecoder()
        JSONDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let decodedVideoListResponse = try JSONDecoder.decode(YouTubeVideoListResponse.self, from: responseData)
            print("Server video list response succesfully fetched to models.")
            return decodedVideoListResponse
            //self.lastValidVideoListResponse = decodedVideoListResponse
            
        } catch {
            print("Error: \(error.localizedDescription)")
            print(error)
            return nil
        }
    }
    
    private func updateLastValidSearchListResponse(forJSONString JSONString: String) {
        let responseData = Data(JSONString.utf8)
        
        let JSONDecoder = JSONDecoder()
        JSONDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let decodedSearchListResponse = try JSONDecoder.decode(YouTubeSearchListResponse.self, from: responseData)
            self.lastValidSearchListResponse = decodedSearchListResponse
            
        } catch {
            print("Error: \(error.localizedDescription)")
            print(error)
        }
        
        print("Server search list response succesfully fetched to models.")
    }
    
    private func initializeYoutubeSearchAPIURL(withSearchText searchText: String, nextPageID: String? = nil) -> URL? {
        var youtubeSearchAPIURL = URLComponents(string: Constants.YOUTUBE_SEARCH_API_URL)!
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
        
        setRequestDefaultValues(request: &request)
        
        return request
    }
    
    public func executeYoutubeSearchAPI(withSearchText searchText: String, nextPageID: String? = nil, shouldRequestDuration: Bool = true) {
        
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
                        self?.updateLastValidSearchListResponse(forJSONString: JSONString)
                        self?.delegate?.updateTableViewDataSource()
                        
                        if let lastValidSearchListResponse = self?.lastValidSearchListResponse, shouldRequestDuration {
                            
                            let videoIds = lastValidSearchListResponse.items.map { $0.id.videoId }
                            self?.executeYoutubeVideoListAPI(videoIds: videoIds) { durations in
                                for index in 0..<lastValidSearchListResponse.items.count {
                                    lastValidSearchListResponse.items[index].duration = durations[index]
                                                
                                    let currentVideoId = lastValidSearchListResponse.items[index].id.videoId
                                    let currentDuration = durations[index]
                                    self?.delegate?.updateTableViewDataSourceItem(id: currentVideoId, duration: currentDuration)
                                }
                                NotificationCenter.default.post(name: .DurationsReceivedNotification, object: nil, userInfo: ["videoIds" : videoIds])
                            }
                        }
                        
                    }
                } else if let response = response as? HTTPURLResponse, response.statusCode == 403 {
                    self?.updateLastValidSearchListResponse(forJSONString: self?.mockResponses.first ?? "")
                    self?.delegate?.updateTableViewDataSource()
                    
                    if let lastValidSearchListResponse = self?.lastValidSearchListResponse, shouldRequestDuration {
                        
                        let videoIds = lastValidSearchListResponse.items.map { $0.id.videoId }
                        self?.executeYoutubeVideoListAPI(videoIds: videoIds) { durations in
                            for index in 0..<lastValidSearchListResponse.items.count {
                                lastValidSearchListResponse.items[index].duration = durations[index]
                                
                                let currentVideoId = lastValidSearchListResponse.items[index].id.videoId
                                let currentDuration = durations[index]
                                self?.delegate?.updateTableViewDataSourceItem(id: currentVideoId, duration: currentDuration)
                            }
                            NotificationCenter.default.post(name: .DurationsReceivedNotification, object: nil)
                        }
                    }
                    
                    
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
