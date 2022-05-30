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

class MusicPlayerSongsViewController: UIViewController, DownloadedSongsTableViewControllerDelegate {
    // TODO:
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    internal var player: AudioPlayer? = nil
    weak var delegate: MusicPlayerSongsViewControllerDelegate? = nil
    
    internal func updatePlayerSongs() {
        self.player = AudioPlayer(songs: self.delegate?.tableData ?? [])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePlayerSongs()
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
            switch player.isPlaying {
            case true:
                player.pause()
            case false:
                player.play()
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
