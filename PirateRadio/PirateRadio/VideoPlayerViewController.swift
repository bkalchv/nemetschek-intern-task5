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
    @IBOutlet weak var ytPlayerView: YTPlayerView!
    var videoId: String = ""
    var downloadDataTask: URLSessionDataTask? = nil
    
    private var lastDownloadedFileLocalDestination: URL?
       
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ytPlayerView.load(withVideoId: videoId)
        loadWebView(videoId: videoId)
        setupBlockingRulesOfWebView()
        downloadButtonsWebView.navigationDelegate = self
        
    }
    
    private func loadWebView(videoId: String) {
        let myURL = Constants.MP3_DOWNLOADER_API_URL!.appendingPathComponent("\(videoId)")
        let myRequest = URLRequest(url: myURL)
        downloadButtonsWebView.load(myRequest)
    }
    
    private func setupBlockingRulesOfWebView() {
        WKContentRuleListStore.default().compileContentRuleList(
            forIdentifier: "ContentBlockingRules",
            encodedContentRuleList: Constants.CONTENT_TO_BLOCK_JSON) { (contentRuleList, error) in
                if let error = error {
                    print("Error compiling blocking rules = \(error)")
                    return
                }
                self.downloadButtonsWebView.configuration.userContentController.add(contentRuleList!)
            }
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
        
        createYoutubeToMp3DownloadsDirectoryInCacheIfNonExistent()
        
        let downloadsDirectory = Constants.YOUTUBE_TO_MP3_DOWNLOADS_DIRECTORY_URL
        
        lastDownloadedFileLocalDestination = downloadsDirectory.appendingPathComponent(suggestedFilename)
        
        removeFileIfExisting(at: lastDownloadedFileLocalDestination!)
        
        completionHandler(lastDownloadedFileLocalDestination!)
    }
    
    func downloadDidFinish(_ download: WKDownload) {
        print("Download finished")
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
}
