//
//  PirateMusicViewController.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 26.05.22.
//

import UIKit

protocol SongsDataSourceDelegate: AnyObject {
    var songs: [Song] { get }
}

extension MusicPlayerSongsViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    // TODO
  }
}

class MusicPlayerSongsViewController: UIViewController, SongPlayerDelegate, AudioPlayerDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var currentSongTitleLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var currentSongRemainingLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    internal var player: AudioPlayer? = nil
    let searchController = UISearchController(searchResultsController: nil)
    weak var songsDataSourceDelegate: SongsDataSourceDelegate!
    
    private func setupMusicPlayerViewInitialState() {
        guard let audioPlayerCurrentSong = songsDataSourceDelegate.songs.first else { return }
        setMusicPlayerViewCurrentSongTitleLabel(title: audioPlayerCurrentSong.title)
        setMusicPlayerViewCurrentSongRemainingLabel(remainingTimeAsString: audioPlayerCurrentSong.duration)
        slider.value = 0.0
        setMusicPlayerViewSliderMaximumValue(maximumValue: Float(player!.getLoadedSongDuration()))
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search in downloaded songs"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Songs"
        player = AudioPlayer(withDelegate: self.songsDataSourceDelegate)
        self.player!.delegate = self
        setupMusicPlayerViewInitialState()
        setupSearchController()
        slider.addTarget(self, action: #selector(sliderDidStartSliding), for: .touchDown)
        slider.addTarget(self, action: #selector(sliderDidEndSliding), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem  = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(onSortButtonPress))
        
        // Do any additional setup after loading the view.
    }
    
    @objc func sliderDidStartSliding() {
        if let player = player, player.isPlaying {
            player.pauseSendingPlaybackUpdates()
        }
    }
    
    @objc func sliderDidEndSliding() {
        let currentSliderValue = slider.value
        player?.play(atTime: Double(currentSliderValue))
    }
    
    @objc func onSortButtonPress() {
        // make popover appear
        let sortButton = self.navigationItem.rightBarButtonItem
        let sortButtonView = sortButton?.value(forKey: "view") as? UIView
        let sortButtonFrame = sortButtonView?.frame
        
        let sortMenuPopoverVC = self.storyboard?.instantiateViewController(withIdentifier: "SortMenuPopoverTableViewController")
        sortMenuPopoverVC?.modalPresentationStyle = .popover
        sortMenuPopoverVC?.view.sizeToFit()
        
        if let popoverPresentantionController = sortMenuPopoverVC?.popoverPresentationController,
           let sortButtonFrame = sortButtonFrame {
            popoverPresentantionController.permittedArrowDirections = .up
            popoverPresentantionController.sourceView = sortButtonView
            popoverPresentantionController.sourceRect = sortButtonFrame
            popoverPresentantionController.delegate = self
            if let sortMenuPopoverVC = sortMenuPopoverVC {
                present(sortMenuPopoverVC, animated: true)
            }
        }
    }
    
    func updatePlayPauseButtonImage() {
        if let player = player {
            playPauseButton.setImage(UIImage(named: player.isPlaying ?
                                             Constants.PAUSE_BUTTON_IMAGE_FILENAME : Constants.PLAY_BUTTON_IMAGE_FILENAME), for: .normal)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onPrevButtonPress(_ sender: Any) {
        if let player = player {
            player.playPreviousSong()
        }
    }
    
    @IBAction func onPlayPauseButtonPress(_ sender: Any) {
        if let player = player {
            if player.isPlaying {
                player.pause()
            }
            else {
                player.play()
            }
            let playPauseButtonImage = UIImage(named: player.isPlaying ? Constants.PAUSE_BUTTON_IMAGE_FILENAME : Constants.PLAY_BUTTON_IMAGE_FILENAME)
            playPauseButton.setImage(playPauseButtonImage, for: .normal)
        }
    }
    
    @IBAction func onNextButtonPress(_ sender: Any) {
        if let player = player {
            player.playNextSong()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let embeddedDownloadedSongsTableVC = segue.destination as? DownloadedSongsTableViewController {
            embeddedDownloadedSongsTableVC.songPlayerDelegate = self
            self.songsDataSourceDelegate = embeddedDownloadedSongsTableVC
        }
        
    }
    
    // MARK: DownloadedSongsTableVCDelegate's methods
    
    func play(song: Song) {
        if let player = player {
            player.load(song: song)
            player.play()
            updatePlayPauseButtonImage()
        }
    }
    
    
    // MARK: AudioPlayerDelegate's methods
    
    internal func setMusicPlayerViewCurrentSongTitleLabel(title: String) {
        currentSongTitleLabel.text = title
    }
    
    internal func setMusicPlayerViewCurrentSongRemainingLabel(remainingTimeAsString: String) {
        currentSongRemainingLabel.text = remainingTimeAsString
    }
    
    internal func setMusicPlayerViewSliderProgress(value: Float) {
        slider.value = value
    }
    
    internal func setMusicPlayerViewSliderMaximumValue(maximumValue: Float) {
        slider.maximumValue = maximumValue
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return true
    }
    
    
}
