//
//  ViewController.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 11.04.22.
//

import UIKit
import YouTubeiOSPlayerHelper

class VideoPlayerViewController: UIViewController {
    
    @IBOutlet weak var downloadMP3Button: UIButton!
    @IBOutlet weak var ytPlayerView: YTPlayerView!
    var videoId: String = ""
    var downloadDataTask: URLSessionDataTask? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ytPlayerView.load(withVideoId: videoId)
    }
    
    func configureYoutubeWatchURL(videoId: String) -> URL? {
        var youtubeURLWithVideoId = URLComponents(string: Constants.YOUTUBE_WATCH_URL_AS_STRING)
        
        let queryItems = [URLQueryItem(name: "v", value: "\(videoId)")]
        
        youtubeURLWithVideoId?.queryItems = queryItems
        
        return youtubeURLWithVideoId?.url
    }
    
    func configureYoutubeDownloaderAPIURL(videoId: String) -> URL? {
        guard let youtubeURLWithVideoId = configureYoutubeWatchURL(videoId: self.videoId) else { return nil }
            
        var downloaderAPIUrl = URLComponents(string: Constants.DOWNLOADER_API_AS_STRING)
        
        let queryItems = [
            URLQueryItem(name: "url", value: youtubeURLWithVideoId.absoluteString),
            URLQueryItem(name: "api_token", value: YOUTUBE_DOWNLOADER_API_TOKEN.value)
        ]
        
        downloaderAPIUrl?.queryItems = queryItems

        return downloaderAPIUrl?.url
    }
    
    private func createYoutubeToMp3DownloadsDirectoryInCacheIfNonExistent() {
        let youtubeToMp3DownloadsDirectoryURL = Constants.YOUTUBE_TO_MP3_DOWNLOADS_DIRECTORY_URL
        
        if !youtubeToMp3DownloadsDirectoryURL.isDirectory {
            do {
                try FileManager.default.createDirectory(at: youtubeToMp3DownloadsDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
    }
    
    func downloadFile(url: URL, filename: String) {
        self.createYoutubeToMp3DownloadsDirectoryInCacheIfNonExistent()
        
        let fileLocalURL = Constants.YOUTUBE_TO_MP3_DOWNLOADS_DIRECTORY_URL.appendingPathComponent(filename)
        
        let downloadFileTask = URLSession.shared.downloadTask(with: url) {
        url, response, error in
            
            guard let tempoararyFileURL = url else { return }
            do {
                print("\(tempoararyFileURL) downloaded.")
                try FileManager.default.moveItem(at: tempoararyFileURL, to: fileLocalURL)
            } catch {
                print("file error: \(error)")
            }
            
            print("\(filename) moved successfully to \(fileLocalURL.absoluteString)")
            
        }
        
        downloadFileTask.resume()
    }
    
    @IBAction func onDownloadMP3ButtonPress(_ sender: Any) {
        
        if let youtubeDownloaderAPIURL = configureYoutubeDownloaderAPIURL(videoId: self.videoId) {
            
            let request = URLRequest(url: youtubeDownloaderAPIURL)
            
            downloadDataTask = URLSession.shared.dataTask(with: request) {
                [weak self] data, response, error in
                defer {
                    self?.downloadDataTask = nil
                }
                
                print("Response code = \((response as! HTTPURLResponse).statusCode)")
                if let error = error {
                    print("Download Data Task error: " + error.localizedDescription)
                } else if let data = data,
                          let response = response as? HTTPURLResponse,
                          response.statusCode == 200 {
                    print("Successful response")
                    
                    if let JSONString = String(data: data, encoding: .utf8) {
                        let responseData = Data(JSONString.utf8)
                        let JSONDecoder = JSONDecoder()
                        JSONDecoder.keyDecodingStrategy = .useDefaultKeys
                        
                        do {
                            let decodedResponse = try JSONDecoder.decode(YoutubeToMp3Response.self, from: responseData)
                            let fileToDownloadURL = decodedResponse.file
                            self?.downloadFile(url: URL(string: fileToDownloadURL)!, filename: ("\(decodedResponse.title).mp3"))
                        } catch {
                            print("Error: \(error.localizedDescription)")
                            print(error)
                        }
                        
                    }
                                        
                }
            }
            
            downloadDataTask?.resume()
            print("Download DataTask started")
        }
        
    }
}
