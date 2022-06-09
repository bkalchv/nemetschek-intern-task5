//
//  LastFMFetcher.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 8.06.22.
//

import Foundation

class LastFMFetcher {
    
    var lastValidTrackSearchResponse: LastFMTrackSearchResponse? = nil
    var dataTask: URLSessionDataTask? = nil
    
    private func initializeLastFMTrackSearchAPIURL(songName: String, songArtist: String? = nil) -> URL? {
        var lastFMSearchTrackAPIURL = URLComponents(string: Constants.LASTFM_SEARCH_TRACK_API_URL)!
        var queryItems = [
            Constants.LASTFM_SEARCH_TRACK_API_SEARCH_TRACK_QUERY_ITEM,
            URLQueryItem(name: "track", value: songName),
            URLQueryItem(name: "api_key", value: LASTFM_API_KEY.value),
            URLQueryItem(name: "format", value: "json")
        ]
        if let songArtist = songArtist {
            queryItems.append(URLQueryItem(name:"artist", value: songArtist))
        }
        lastFMSearchTrackAPIURL.queryItems = queryItems
        
        return lastFMSearchTrackAPIURL.url
    }
    
    private func setRequestDefaultValues(request: inout URLRequest) {
        request.setValue(Constants.IOS_BUNDLE_IDENTIFIER_HEADER, forHTTPHeaderField: Constants.IOS_BUNDLE_IDENTIFIER_HEADER_FIELD)
        request.setValue(Constants.USER_AGENT, forHTTPHeaderField: Constants.USER_AGENT_FIELD)
        request.setValue(Constants.CONTENT_TYPE, forHTTPHeaderField: Constants.CONTENT_TYPE_FIELD)
    }
    
    private func initializeLastFMTrackSearchURLRequest(songName: String, songArtist: String? = nil) -> URLRequest? {
        guard let lastFMTrackSearchAPIURL = initializeLastFMTrackSearchAPIURL(songName: songName, songArtist: songArtist) else { return nil }
        
        print(lastFMTrackSearchAPIURL.absoluteString)
        
        var request = URLRequest(url: lastFMTrackSearchAPIURL)
        
        setRequestDefaultValues(request: &request)
        
        return request
    }
    
    public func executeLastFMTrackSearchAPI(songName: String, songArtist: String? = nil) {
        if let request = initializeLastFMTrackSearchURLRequest(songName: songName, songArtist: songArtist) {
            
            dataTask = URLSession.shared.dataTask(with: request) {
                [weak self] data, response, error in
                defer {
                    self?.dataTask = nil
                }
                
                print("LastFM TrackSearch's response code \((response as! HTTPURLResponse).statusCode)")
                if let error = error {
                    // TODO: Erro handling?
                    print("DataTask error: \(error)")
                } else if let data = data,
                          let response = response as? HTTPURLResponse,
                          response.statusCode == 200 {
                    if let JSONString = String(data: data, encoding: .utf8) {
                        print(JSONString)
                        print("Fetch me")
                    }
                }
            }
            
        }
    }
}
