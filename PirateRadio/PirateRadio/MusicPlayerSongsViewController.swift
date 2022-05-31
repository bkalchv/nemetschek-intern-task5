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
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    internal var player: AudioPlayer? = nil
    weak var delegate: MusicPlayerSongsViewControllerDelegate!
    
    internal func updateAudioPlayerSongs() {
        self.player = AudioPlayer(songs: delegate.tableData)
    }
    
    internal func updateMusicPlayerViewCurrentSongTitleLabel(title: String) {
        currentSongTitleLabel.text = title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateAudioPlayerSongs()
        updateMusicPlayerViewCurrentSongTitleLabel(title: self.delegate?.tableData.first?.title ?? "Title")
        self.player?.delegate = self
        // Do any additional setup after loading the view.
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
                player.playPrev()
            } else {
                print("Not implemented yet!")
            }
        }
    }
    
    @IBAction func onPlayPauseButtonPress(_ sender: Any) {
        if let player = player {
            if player.isPlaying {
                // TODO: load play button
                player.pause()
                playPauseButton.setImage(UIImage(named: Constants.PLAY_BUTTON_IMAGE_FILENAME), for: .normal)
            } else {
                // TODO: load pause button
                player.play()
                playPauseButton.setImage(UIImage(named: Constants.PAUSE_BUTTON_IMAGE_FILENAME), for: .normal)
            }
        }
    }
    
    @IBAction func onNextButtonPress(_ sender: Any) {
        if let player = player {
            if player.isPlaying {
                player.playNext()
            } else {
                print("Not implemented yet!")
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
