//
//  LastFMFetcher.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 8.06.22.
//

import Foundation

class LastFMFetcher: NSObject, URLSessionDelegate, URLSessionDataDelegate, URLSessionDownloadDelegate {
    
    //var lastValidTrackSearchResponse: LastFMTrackSearchResponse? = nil
    var dataTask: URLSessionDataTask?
    var observation: NSKeyValueObservation?
    
    private func initializeLastFMAPITrackGetInfoURL(trackName: String, artistName: String) -> URL? {
        var lastFMAPITrackGetInfoURL = URLComponents(string: Constants.LASTFM_API_URL)!
        let queryItems = [
            Constants.LASTFM_API_TRACK_GET_INFO_QUERY_ITEM,
            URLQueryItem(name: "api_key", value: LASTFM_API_KEY.value),
            URLQueryItem(name: "track", value: trackName),
            URLQueryItem(name: "artist", value: artistName),
            URLQueryItem(name: "format", value: "json")
        ]
        lastFMAPITrackGetInfoURL.queryItems = queryItems
        
        return lastFMAPITrackGetInfoURL.url
    }
    
    
    private func initializeLastFMAPITrackGetInfoURLRequest(trackName: String, artistName: String) -> URLRequest? {
        guard let lastFMAPITrackGetInfoURL = initializeLastFMAPITrackGetInfoURL(trackName: trackName, artistName: artistName) else { return nil }
        print(lastFMAPITrackGetInfoURL.absoluteString)
        
        var request = URLRequest(url: lastFMAPITrackGetInfoURL)
        
        setRequestDefaultValues(request: &request)
        
        return request
    }
    
    private func initializeLastFMAPITrackSearchURL(songName: String, songArtist: String? = nil) -> URL? {
        var lastFMAPITrackSearchURL = URLComponents(string: Constants.LASTFM_API_URL)!
        var queryItems = [
            Constants.LASTFM_API_TRACK_SEARCH_QUERY_ITEM,
            URLQueryItem(name: "track", value: songName),
            URLQueryItem(name: "api_key", value: LASTFM_API_KEY.value),
            URLQueryItem(name: "format", value: "json")
        ]
        if let songArtist = songArtist {
            queryItems.append(URLQueryItem(name:"artist", value: songArtist))
        }
        lastFMAPITrackSearchURL.queryItems = queryItems
        
        return lastFMAPITrackSearchURL.url
    }
    
    private func trackGetInfoResponse(forJSONString JSONString: String) -> TrackGetInfoResponse? {
        let responseData = Data(JSONString.utf8)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let decodedTrackSearchResponse = try decoder.decode(TrackGetInfoResponse.self, from: responseData)
            return decodedTrackSearchResponse
        } catch {
            print("Error by decoding: \(error)")
            print("Localcized description: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func setRequestDefaultValues(request: inout URLRequest) {
        request.setValue(Constants.IOS_BUNDLE_IDENTIFIER_HEADER, forHTTPHeaderField: Constants.IOS_BUNDLE_IDENTIFIER_HEADER_FIELD)
        request.setValue(Constants.USER_AGENT, forHTTPHeaderField: Constants.USER_AGENT_FIELD)
        request.setValue(Constants.CONTENT_TYPE, forHTTPHeaderField: Constants.CONTENT_TYPE_FIELD)
    }
    
    private func initializeLastFMAPITrackSearchURLRequest(songName: String, songArtist: String? = nil) -> URLRequest? {
        guard let lastFMTrackSearchAPIURL = initializeLastFMAPITrackSearchURL(songName: songName, songArtist: songArtist) else { return nil }
        
        print(lastFMTrackSearchAPIURL.absoluteString)
        
        var request = URLRequest(url: lastFMTrackSearchAPIURL)
        
        setRequestDefaultValues(request: &request)
        
        return request
    }
    
    private func trackSearchResponse(forJSONString JSONString: String) -> LastFMTrackSearchResponse? {
        let responseData = Data(JSONString.utf8)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let decodedTrackSearchResponse = try decoder.decode(LastFMTrackSearchResponse.self, from: responseData)
            return decodedTrackSearchResponse
        } catch {
            print("Error by decoding: \(error)")
            print("Localcized description: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func createAlbumArtworksDirectoryInCacheIfNonExistent() {
        let albumArtworksDirectoryURL = Constants.ALBUM_ARTWORK_DIRECTORY_URL
        
        if !albumArtworksDirectoryURL.isDirectory {
            do {
                try FileManager.default.createDirectory(at: albumArtworksDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
    }
        
    private func firstSearchResultSongName(trackSearchResponse: LastFMTrackSearchResponse) -> String? {
        if let firstMatch = trackSearchResponse.results.trackmatches.track.first {
            return firstMatch.name
        } else {
            return nil
        }
    }
    
    private func firstSearchResultArtistName(trackSearchResponse: LastFMTrackSearchResponse) -> String? {
        if let firstMatch = trackSearchResponse.results.trackmatches.track.first {
            return firstMatch.artist
        } else {
            return nil
        }
    }
    
    public func executeLastFMAPITrackSearch(songName: String, songArtist: String?, shouldFindSongsAlbum: Bool = true) {
        if let request = initializeLastFMAPITrackSearchURLRequest(songName: songName, songArtist: songArtist) {
            
            dataTask = URLSession.shared.dataTask(with: request) {
                [weak self] data, response, error in
                defer {
                    self?.dataTask = nil
                }
                
                print("LastFM API TrackSearch's response code \((response as! HTTPURLResponse).statusCode)")
                if let error = error {
                    // TODO: Error handling?
                    print("DataTask error: \(error)")
                } else if let data = data,
                          let response = response as? HTTPURLResponse,
                          response.statusCode == 200 {
                    if let trackSearchJSONString = String(data: data, encoding: .utf8) {
                        //print(JSONString)
                        if let trackSearchResponse = self?.trackSearchResponse(forJSONString: trackSearchJSONString),
                           let trackName = self?.firstSearchResultSongName(trackSearchResponse: trackSearchResponse),
                           let trackArtistName = self?.firstSearchResultArtistName(trackSearchResponse: trackSearchResponse),
                           shouldFindSongsAlbum {
                            
                            if let getInfoRequest = self?.initializeLastFMAPITrackGetInfoURLRequest(trackName: trackName, artistName: trackArtistName) {
                                let dataTask = URLSession.shared.dataTask(with: getInfoRequest)  {[weak self] data, response, error in
                                    
                                    print("LastFM API GetInfo's response code \((response as! HTTPURLResponse).statusCode)")
                                    
                                    if let error = error {
                                        print("DataTask error: \(error)")
                                    } else if let data = data,
                                              let response = response as? HTTPURLResponse,
                                              response.statusCode == 200 {
                                        if let trackGetInfoJSONString = String(data: data, encoding: .utf8),
                                           let trackGetInfoResponse = self?.trackGetInfoResponse(forJSONString: trackGetInfoJSONString),
                                           let albumName = trackGetInfoResponse.track.album?.title,
                                           let albumExtraLargeImage = trackGetInfoResponse.track.album?.imageExtraLargeURL,
                                           !albumExtraLargeImage.isEmpty {
                                    
                                            self?.createAlbumArtworksDirectoryInCacheIfNonExistent()
                                            let imageURL = URL(string: albumExtraLargeImage)!
                                            let downloadTask = URLSession.shared.downloadTask(with: imageURL) { url, response, error in
                                                if let error = error {
                                                    print("DownloadTask error: \(error)")
                                                } else {
                                                    guard let tempURL = url else { return }
                                                    
                                                    let artworkFileLocalURL = Constants.ALBUM_ARTWORK_DIRECTORY_URL.appendingPathComponent(imageURL.lastPathComponent)
                                                    
                                                    try? FileManager.default.moveItem(at: tempURL, to: artworkFileLocalURL)
                                                    
                                                    RealmWrapper.updateAlbumsProperties(songName: songName, songArtist: songArtist, albumName: albumName, albumArtworkFilename: artworkFileLocalURL.lastPathComponent)
                                                    print("Database updated!")
                                                }
                                            }
                                            
                                            self?.observation = downloadTask.progress.observe(\.fractionCompleted) { progress, _ in
                                                let progressPercent = Int(Double(progress.fractionCompleted) * 100)
                                                print("Artwork download's download progress: \(progressPercent)%")
                                            }
                                            
                                            downloadTask.resume()
                                            print("DownloadTask started")
                                        }
                                    }
                                    
                                }
                                dataTask.resume()
                                print("DataTask2 started")
                            }
                            
                        }
                    }
                }
            }
            
            dataTask?.resume()
            print("DataTask started")
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("\(totalBytesWritten) bytes'\'\(totalBytesExpectedToWrite) bytes downloaded")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("I finished downloading")
    }
}
