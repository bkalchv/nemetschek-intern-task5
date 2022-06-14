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
import RealmSwift
import AVFoundation

class VideoPlayerViewController: UIViewController, YTPlayerViewDelegate, WKUIDelegate, WKDownloadDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var downloadButtonsWebView: WKWebView!
    @IBOutlet weak var ytPlayerView: YTPlayerView!
    @IBOutlet weak var pirateModeView: UIView!
    var videoId: String = ""
    static var appHasEnteredBackgroundMode: Bool = false
    static var isPirateModeOn: Bool {
        get { return UserDefaults.standard.bool(forKey: "isPirateModeOn") }
    }
    static var hasSwipedDownOnPirateModeView: Bool = false
    static var tapsOnPirateModeView: Int = 0
    static var hasTappedOnPirateModeViewThreeTimes: Bool {
        get { tapsOnPirateModeView >= 3 }
    }
    var gestureTimer: Timer?
    private var filenameForDownload: [WKDownload : String] = [:]
    private var downloadProgressObserver: NSKeyValueObservation?
    var lastFMFetcher: LastFMFetcher?
       
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ytPlayerView.load(withVideoId: videoId)
        ytPlayerView.delegate = self
        setupDownloadButtonsWebView()
        setupPirateModeView()
        lastFMFetcher = LastFMFetcher()
        
        NotificationCenter.default.addObserver(self, selector: #selector(activatePirateMode), name: .PirateModeRequirementsFulfilledNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        downloadProgressObserver?.invalidate()
        downloadProgressObserver = nil
    }
    
    @objc func onGestureTimerFired() {
        if VideoPlayerViewController.hasTappedOnPirateModeViewThreeTimes {
            NotificationCenter.default.post(name: .PirateModeRequirementsFulfilledNotification, object: nil)
        } else {
            VideoPlayerViewController.hasSwipedDownOnPirateModeView = false
            VideoPlayerViewController.tapsOnPirateModeView = 0
        }
    }
    
    @objc func activatePirateMode() {
        
        UserDefaults.standard.set(true, forKey: "isPirateModeOn")
        
        // MARK: Disabling User Interaction!
        pirateModeView.isUserInteractionEnabled = false
        
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
        if VideoPlayerViewController.hasSwipedDownOnPirateModeView {
            VideoPlayerViewController.tapsOnPirateModeView += 1
            
            if VideoPlayerViewController.hasTappedOnPirateModeViewThreeTimes {
                gestureTimer!.fire()
            }
        }
    }
    
    @objc func onPirateModeViewSwipeDown() {
        
        if gestureTimer != nil {
            self.gestureTimer!.invalidate()
            print("Gesture timer invalidated")
        }
        
        gestureTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(onGestureTimerFired), userInfo: nil, repeats: false)
        print("New gesture timer initialized")
        VideoPlayerViewController.hasSwipedDownOnPirateModeView = true
    }
    
    @objc func willResignActive() {
        VideoPlayerViewController.appHasEnteredBackgroundMode = true
    }
    
    @objc func appCameToForeground() {
        VideoPlayerViewController.appHasEnteredBackgroundMode = false
    }
    
    @objc func playVideo() {
        self.ytPlayerView.playVideo()
    }
    
    private func setupDownloadButtonsWebView() {
        downloadButtonsWebView.isUserInteractionEnabled = VideoPlayerViewController.isPirateModeOn
        downloadButtonsWebView.isHidden = !VideoPlayerViewController.isPirateModeOn
        downloadButtonsWebView.scrollView.isScrollEnabled = false
        downloadButtonsWebView.navigationDelegate = self
        loadDownloadButtonsWebView(videoId: videoId)
        setupBlockingRulesOfWebView()
    }
    
    private func setupPirateModeView() {
                
        if VideoPlayerViewController.isPirateModeOn {
            return
        }
        
        let swipeGestureRecognizerDown = UISwipeGestureRecognizer(target: self, action: #selector(onPirateModeViewSwipeDown))
        
        swipeGestureRecognizerDown.direction = .down
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onPirateModeViewTap))
        
        pirateModeView.addGestureRecognizer(swipeGestureRecognizerDown)
        pirateModeView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch state {
        case .paused:
            if VideoPlayerViewController.appHasEnteredBackgroundMode && VideoPlayerViewController.isPirateModeOn { NotificationCenter.default.post(name: .PlayVideoNotification, object: nil) }
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
        let downloadLocation = downloadsDirectory.appendingPathComponent(suggestedFilename)
        removeFileIfExisting(at: downloadLocation)
        
        self.view.makeToast("Starting to download...")
        
        filenameForDownload[download] = suggestedFilename
        
        downloadProgressObserver = download.progress.observe(\.fractionCompleted) {
            progress, _ in
            let progressPercent = Int(progress.fractionCompleted * 100)
            print("Song's download progress: \(progressPercent)%")
        }
        
        completionHandler(downloadLocation)
    }
       
    private func extractArtistFromFilename(filename: String) -> String {
        let delimiter = "-"
        if filename.contains(delimiter) {
            let artistName = filename.components(separatedBy: delimiter).first ?? Constants.SONG_DEFAULT_ARTIST_VALUE
            return artistName.trimmingCharacters(in: .whitespaces)
        } else {
            return Constants.SONG_DEFAULT_ARTIST_VALUE
        }
    }
    
    private func extractTitleFromFilename(filename: String) -> String {
        let delimiter: Character = "-"
        if let delimiterFirstAppearance = filename.firstIndex(of: delimiter) {
            var title = String(filename[filename.index(after: delimiterFirstAppearance)...])
            title = (title as NSString).deletingPathExtension
            title = title.replacingOccurrences(of: "\\s?\\([\\w\\s]*\\)|\\s?\\([\\S]*\\)", with: "", options: .regularExpression)
            return title.trimmingCharacters(in: .whitespaces)
        } else {
            return filename
        }
    }
    
    private func durationForFile(url: URL) -> String {
        let audioAsset = AVAsset(url: url)
        return audioAsset.duration.positionalTime
    }
    
    func downloadDidFinish(_ download: WKDownload) {
        self.view.makeToast("MP3 downloaded successfully!")
        print("MP3 downloaded successfully")
                        
        // TODO: durationForFile not working with fileURLWithPath
        let filename = filenameForDownload[download]!
        let fileURL = Constants.YOUTUBE_TO_MP3_DOWNLOADS_DIRECTORY_URL.appendingPathComponent(filename)
        let song = Song.create(title: self.extractTitleFromFilename(filename: filename), artist: self.extractArtistFromFilename(filename: filename), duration: self.durationForFile(url: fileURL), filename: filename)
        // TODO: write to database
        RealmWrapper.addSong(song)
        
        lastFMFetcher?.executeLastFMAPITrackSearch(songName: song.title, songArtist: song.artist)
        
        NotificationCenter.default.post(name: .DidFinishDownloadingMP3File, object: nil)
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
