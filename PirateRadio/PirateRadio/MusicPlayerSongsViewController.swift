//
//  PirateMusicViewController.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 26.05.22.
//

import UIKit

protocol MusicPlayerSongsViewControllerDelegate: AnyObject {
    var tableData: [Song] { get }
}

class MusicPlayerSongsViewController: UIViewController, DownloadedSongsTableViewControllerDelegate, AudioPlayerDelegate {
    @IBOutlet weak var currentSongTitleLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var currentSongRemainingLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    internal var player: AudioPlayer? = nil
    weak var delegate: MusicPlayerSongsViewControllerDelegate!
    
    private func setupMusicPlayerViewInitialState() {
        let audioPlayerCurrentSong = self.player!.getCurrentSong()
        setMusicPlayerViewCurrentSongTitleLabel(title: audioPlayerCurrentSong.title)
        setMusicPlayerViewCurrentSongRemainingLabel(remainingTimeAsString: audioPlayerCurrentSong.duration)
        slider.value = 0.0
        setMusicPlayerViewSliderMaximumValue(maximumValue: Float(player!.getLoadedSongDuration()))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player = AudioPlayer(songs: self.delegate.tableData)
        // TODO: Ask if that's a good place assign player's delegate
        self.player!.delegate = self
        setupMusicPlayerViewInitialState()
        NotificationCenter.default.addObserver(self, selector: #selector(updatePlayPauseButtonImage), name: .SongSelectedNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func updatePlayPauseButtonImage() {
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
            if player.isPlaying {
                player.playPreviousSong()
            } else {
                player.loadPreviousSong()
            }
        }
    }
    
    @IBAction func onPlayPauseButtonPress(_ sender: Any) {
        if let player = player {
            if player.isPlaying {
                player.pause()
            } else {
                player.play()
            }
            updatePlayPauseButtonImage()
        }
    }
    
    @IBAction func onNextButtonPress(_ sender: Any) {
        if let player = player {
            if player.isPlaying {
                player.playNextSong()
            } else {
                player.loadNextSong()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let embeddedDownloadedSongsTableVC = segue.destination as? DownloadedSongsTableViewController {
            embeddedDownloadedSongsTableVC.delegate = self
            self.delegate = embeddedDownloadedSongsTableVC
        }
        
    }
    
    // MARK: DownloadedSongsTableVCDelegate's methods
    // commented because of // TODO: Notify AudioPlayer that tableData has been updated, instead of delegation?
//    internal func updateAudioPlayerSongs(newSongs: [Song]) {
//        guard let player = player else { return }
//        player.updateSongs(songs: newSongs)
//        player
//            .setupInitialState()
//        setupMusicPlayerViewInitialState()
//    }
    
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
    
    
}
