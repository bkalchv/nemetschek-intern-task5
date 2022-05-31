//
//  AudioPlayer.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 30.05.22.
//

import UIKit
import AVFAudio

protocol AudioPlayerDelegate: AnyObject {
    func updateMusicPlayerViewCurrentSongTitleLabel(title: String)
    func updateMusicPlayerViewCurrentSongDurationLabel(duration: String)
}

class AudioPlayer {
    private var songs: [Song] = []
    private var currentSongIndex: Int = 0
    private var audioPlayer: AVAudioPlayer? = nil
    private var timer: Timer? = nil
    public var isPlaying: Bool {
        get {
            if let audioPlayer = audioPlayer {
                return audioPlayer.isPlaying
            } else {
                return false
            }
        }
    }
    weak var delegate: AudioPlayerDelegate? = nil
        
    public init(songs: [Song]) {
        if !songs.isEmpty {
            self.songs = songs
            setupAudioPlayer(song: songs.first!)
        }
    }
    
    private func setupAudioPlayer(song: Song) {
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: song.localURL)
        } catch let error {
            print(error)
        }
        
//        if timer == nil {
//            timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
//        }
    }
    
    public func play() {
        if let audioPlayer = audioPlayer {
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }
    }
    
    public func pause() {
        if let audioPlayer = audioPlayer {
            audioPlayer.pause()
        }
    }
    
    private func updateAudioPlayerCurrentSong() {
        
        let currentSong = songs[currentSongIndex]
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: currentSong.localURL)
        } catch let error {
            print(error)
        }
        
        self.delegate?.updateMusicPlayerViewCurrentSongTitleLabel(title: currentSong.title)
        delegate?.updateMusicPlayerViewCurrentSongDurationLabel(duration: currentSong.duration)
    }
    
    private func loadSongAtIndex(index: Int) {
        if index >= 0 && index < songs.count {
            currentSongIndex = index
            if self.isPlaying { self.pause() }
            updateAudioPlayerCurrentSong()
        }
    }
    
    public func loadNextSong() {
        if currentSongIndex + 1 < songs.count {
            loadSongAtIndex(index: currentSongIndex + 1)
        }
    }
    
    public func loadPreviousSong() {
        if currentSongIndex - 1 >= 0 {
            loadSongAtIndex(index: currentSongIndex - 1)
        }
    }

    public func playNextSong() {
        if currentSongIndex + 1 < songs.count {
            loadNextSong()
            self.play()
        }
    }
    
    public func playPreviousSong() {
        if currentSongIndex - 1 >= 0 {
            loadPreviousSong()
            self.play()
        }
    }
    
    public func playSongAtIndex(index: Int) {
        if index >= 0 && index < songs.count {
            loadSongAtIndex(index: index)
            self.play()
        }
    }
    
    public func getCurrentSong() -> Song {
        return songs[currentSongIndex]
    }
    
    
//    @objc private func updateProgress() {
//
//    }
}

// Play next song when on audioPlayerDidFinishPlaying
//extension AudioPlayerView: AVAudioPlayerDelegate {
//    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        <#code#>
//    }
//}
