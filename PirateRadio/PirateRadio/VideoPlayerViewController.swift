//
//  ViewController.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 11.04.22.
//

import WebKit
import UIKit
import YouTubeiOSPlayerHelper
import Toast

class VideoPlayerViewController: UIViewController, YTPlayerViewDelegate, WKUIDelegate, WKDownloadDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var downloadButtonsWebView: WKWebView!
    @IBOutlet weak var ytPlayerView: YTPlayerView!
    @IBOutlet weak var pirateModeView: UIView!
    var videoId: String = ""
    var appHasEnteredBackgroundMode: Bool = false
    var isPirateModeOn: Bool = false
    var hasSwipedDownOnPirateModeView: Bool = false
    var tapsOnPirateModeView: Int = 0
    var hasTappedOnPirateModeViewThreeTimes: Bool {
        get { tapsOnPirateModeView >= 3 }
    }
    
    private var lastDownloadedFileLocalDestination: URL?
       
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ytPlayerView.load(withVideoId: videoId)
        ytPlayerView.delegate = self
        downloadButtonsWebView.isUserInteractionEnabled = false
        downloadButtonsWebView.isHidden = true
        downloadButtonsWebView.scrollView.isScrollEnabled = false
        downloadButtonsWebView.navigationDelegate = self
        loadDownloadButtonsWebView(videoId: videoId)
        setupBlockingRulesOfWebView()
        
        let swipeGestureRecognizerDown = UISwipeGestureRecognizer(target: self, action: #selector(onPirateModeViewSwipeDown))
        
        swipeGestureRecognizerDown.direction = .down
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onPirateModeViewTap))
        
        pirateModeView.addGestureRecognizer(swipeGestureRecognizerDown)
        pirateModeView.addGestureRecognizer(tapGestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(activatePirateMode), name: .PirateModeRequirementsFulfilledNotification, object: nil)
    }
    
    @objc func activatePirateMode() {
        isPirateModeOn = true
        
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIScene.willDeactivateNotification, object: nil)
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(appCameToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playVideo), name: .PlayVideoNotification, object: nil)
        
        downloadButtonsWebView.isUserInteractionEnabled = true
        downloadButtonsWebView.isHidden = false
        
        self.view.makeToast("You've entered pirate mode!")
    }
    
    @objc func onPirateModeViewTap() {
        if hasSwipedDownOnPirateModeView {
            tapsOnPirateModeView += 1
        }
        
        if hasSwipedDownOnPirateModeView && hasTappedOnPirateModeViewThreeTimes {
            NotificationCenter.default.post(name: .PirateModeRequirementsFulfilledNotification, object: nil)
        }
    }
    
    @objc func onPirateModeViewSwipeDown() {
        hasSwipedDownOnPirateModeView = true
    }
    
    @objc func willResignActive() {
        appHasEnteredBackgroundMode = true
    }
    
    @objc func appCameToForeground() {
        appHasEnteredBackgroundMode = false
    }
    
    @objc func playVideo() {
        self.ytPlayerView.playVideo()
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch state {
        case .paused:
            if appHasEnteredBackgroundMode && isPirateModeOn { NotificationCenter.default.post(name: .PlayVideoNotification, object: nil) }
        default:
            break
        }
    }
        
    private func loadDownloadButtonsWebView(videoId: String) {
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
        
        if responseUrl!.pathComponents.contains("download")
            && responseUrl!.pathComponents.contains(videoId)
            && responseUrl!.pathComponents.contains("mp3") {
            decisionHandler(.download)
            return
        }
        
        if navigationResponse.canShowMIMEType {
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
        
        self.view.makeToast("Starting to download...")
        
        completionHandler(lastDownloadedFileLocalDestination!)
    }
    
    func downloadDidFinish(_ download: WKDownload) {
        self.view.makeToast("MP3 downloaded successfully!")
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
