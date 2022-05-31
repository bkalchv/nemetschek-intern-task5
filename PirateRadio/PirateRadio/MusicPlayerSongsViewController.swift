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
    
    internal func updateAudioPlayerSongs() {
        // TODO: Ask if using the initiializer like that is appropriate
        self.player = AudioPlayer(songs: delegate.tableData)
    }
    
    internal func setMusicPlayerViewCurrentSongTitleLabel(title: String) {
        currentSongTitleLabel.text = title
    }
    
    internal func setMusicPlayerViewCurrentSongRemainingLabel(duration: String) {
        currentSongRemainingLabel.text = duration
    }
    
    func setSliderProgress(value: Float) {
        slider.value = value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateAudioPlayerSongs()
        // TODO: Ask if that's a good place assign player's delegate
        self.player?.delegate = self
        setupMusicPlayerViewInitialState()
        // Do any additional setup after loading the view.
    }
    
    private func setupMusicPlayerViewInitialState() {
        let audioPlayerCurrentSong = self.player!.getCurrentSong()
        setMusicPlayerViewCurrentSongTitleLabel(title: audioPlayerCurrentSong.title)
        setMusicPlayerViewCurrentSongRemainingLabel(duration: audioPlayerCurrentSong.duration)
        slider.value = 0.0
        slider.maximumValue = Float(self.player!.getLoadedSongDuration())
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
                playPauseButton.setImage(UIImage(named: Constants.PLAY_BUTTON_IMAGE_FILENAME), for: .normal)
            } else {
                player.play()
                playPauseButton.setImage(UIImage(named: Constants.PAUSE_BUTTON_IMAGE_FILENAME), for: .normal)
            }
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
    
}
