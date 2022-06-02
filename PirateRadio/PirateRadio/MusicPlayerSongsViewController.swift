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

class MusicPlayerSongsViewController: UIViewController, SongPlayerDelegate, AudioPlayerDelegate {
    
    @IBOutlet weak var currentSongTitleLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var currentSongRemainingLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    internal var player: AudioPlayer? = nil
    weak var songsDataSourceDelegate: SongsDataSourceDelegate!
    
    private func setupMusicPlayerViewInitialState() {
        guard let audioPlayerCurrentSong = songsDataSourceDelegate.songs.first else { return }
        setMusicPlayerViewCurrentSongTitleLabel(title: audioPlayerCurrentSong.title)
        setMusicPlayerViewCurrentSongRemainingLabel(remainingTimeAsString: audioPlayerCurrentSong.duration)
        slider.value = 0.0
        setMusicPlayerViewSliderMaximumValue(maximumValue: Float(player!.getLoadedSongDuration()))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player = AudioPlayer(withDelegate: self.songsDataSourceDelegate)
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
    
    
}
