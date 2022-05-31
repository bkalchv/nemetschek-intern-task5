//
//  AudioPlayer.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 30.05.22.
//

import UIKit
import AVFAudio

protocol AudioPlayerDelegate: AnyObject {
    func setMusicPlayerViewCurrentSongTitleLabel(title: String)
    func setMusicPlayerViewCurrentSongRemainingLabel(duration: String)
    func setSliderProgress(value: Float)
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
        
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(updateSliderProgress), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func updateSliderProgress() {
        self.delegate?.setSliderProgress(value: Float(self.audioPlayer!.currentTime))
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
        
        self.delegate?.setMusicPlayerViewCurrentSongTitleLabel(title: currentSong.title)
        delegate?.setMusicPlayerViewCurrentSongRemainingLabel(duration: currentSong.duration)
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
    
    public func getLoadedSongDuration() -> TimeInterval {
        return audioPlayer!.duration
    }
}

// Play next song when on audioPlayerDidFinishPlaying
//extension AudioPlayerView: AVAudioPlayerDelegate {
//    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        <#code#>
//    }
//}
