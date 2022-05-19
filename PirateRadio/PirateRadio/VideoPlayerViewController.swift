//
//  ViewController.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 11.04.22.
//

import WebKit
import UIKit
import YouTubeiOSPlayerHelper

class VideoPlayerViewController: UIViewController, WKUIDelegate, WKDownloadDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var downloadButtonsWebView: WKWebView!
    @IBOutlet weak var downloadMP3Button: UIButton!
    @IBOutlet weak var ytPlayerView: YTPlayerView!
    var videoId: String = ""
    var downloadDataTask: URLSessionDataTask? = nil
    
    private var filePathLocalDestination: URL?
    //weak var downloadDelegate: WebDownloadable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ytPlayerView.load(withVideoId: videoId)
        
        let myURL = URL(string: "https://api.vevioz.com/api/button/mp3/\(videoId)") // api.vevioz buttons (-) have lots of ads
        
        // https://dozubatan.com/400/4679028
        
        let contentToBlock = """
                                [
                                    { "trigger": {
                                      "url-filter": "dozubatan.com*"
                                    },
                                    "action": {
                                      "type": "block"
                                    }
                                  },
                                    { "trigger": {
                                      "url-filter": "pseepsie.com*"
                                    },
                                    "action": {
                                      "type": "block"
                                    }
                                  },
                                    { "trigger": {
                                      "url-filter": "toglooman.com*"
                                    },
                                    "action": {
                                      "type": "block"
                                    }
                                  },
                                    { "trigger": {
                                      "url-filter": "my.rtmark.net*"
                                    },
                                    "action": {
                                      "type": "block"
                                    }
                                  },
                                    { "trigger": {
                                      "url-filter": "interstitial-07.com*"
                                    },
                                    "action": {
                                      "type": "block"
                                    }
                                  },
                            
                                    { "trigger": {
                                      "url-filter": "w0wtimelands.com*"
                                    },
                                    "action": {
                                      "type": "block"
                                    }
                                  },
                                  { "trigger": {
                                    "url-filter": "googleads.g.doubleclick.net*"
                                  },
                                  "action": {
                                    "type": "block"
                                  }
                                },
                                {
                                  "trigger": {
                                    "url-filter": "pagead.googlesyndication.com*"
                            
                                  },
                                  "action": {
                                    "type": "block"
                                  }
                                },
                                {
                                  "trigger": {
                                    "url-filter": "pagead1.googlesyndication.com*"
                            
                                  },
                                  "action": {
                                    "type": "block"
                                  }
                                },
                                {
                                  "trigger": {
                                    "url-filter": "pagead2.googlesyndication.com*"
                            
                                  },
                                  "action": {
                                    "type": "block"
                                  }
                            }
                                ]
                            """
        
        WKContentRuleListStore.default().compileContentRuleList(
            forIdentifier: "ContentBlockingRules",
            encodedContentRuleList: contentToBlock) { (contentRuleList, error) in
                if let error = error {
                    print("error compiling rules = \(error)")
                    return
                }
                self.downloadButtonsWebView.configuration.userContentController.add(contentRuleList!)
            }
                
                let myRequest = URLRequest(url: myURL!)
                downloadButtonsWebView.load(myRequest)
                downloadButtonsWebView.navigationDelegate = self
            }
        
        // MARK: WKNavigationDelegate's methods
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
            if navigationAction.shouldPerformDownload {
                decisionHandler(.download, preferences)
            } else {
                decisionHandler(.allow, preferences)
            }
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
            
            let responseUrl = navigationResponse.response.url
            print(responseUrl!.absoluteString)
            
            //TODO: if pathComponents
            if responseUrl!.pathComponents.contains("download")
                && responseUrl!.pathComponents.contains(videoId)
                && responseUrl!.pathComponents.contains("mp3") {
                decisionHandler(.download)
                return
            }
            
            if navigationResponse.canShowMIMEType {
                //print(navigationResponse)
                decisionHandler(.allow)
            } else {
                decisionHandler(.download)
            }
        }
        
        // MARK: WKDonwloadDelegate's methods
        
        func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, didBecome download: WKDownload) {
            download.delegate = self
        }
        
        func webView(_ webView: WKWebView, navigationResponse: WKNavigationResponse, didBecome download: WKDownload) {
            download.delegate = self
        }
        
        private func removeFileIfExisting(at url: URL) {
            if FileManager.default.fileExists(atPath: url.absoluteString) {
                do {
                    try FileManager.default.removeItem(at: url)
                } catch {
                    print(error)
                }
            }
        }
        
        func download(_ download: WKDownload, decideDestinationUsing response: URLResponse, suggestedFilename: String, completionHandler: @escaping (URL?) -> Void) {
            
            let downloadsDirectory = Constants.YOUTUBE_TO_MP3_DOWNLOADS_DIRECTORY_URL
            
            filePathLocalDestination = downloadsDirectory.appendingPathComponent(suggestedFilename)
            
            removeFileIfExisting(at: filePathLocalDestination!)
            
            print(filePathLocalDestination!.absoluteString)
            
            completionHandler(filePathLocalDestination!)
        }
        
        func downloadDidFinish(_ download: WKDownload) {
            print("Download finished")
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
        
        func downloadMP3(url: URL, filename: String) {
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
                                self?.downloadMP3(url: URL(string: fileToDownloadURL)!, filename: ("\(decodedResponse.title).mp3"))
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
