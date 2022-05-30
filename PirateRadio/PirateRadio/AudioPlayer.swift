//
//  AudioPlayer.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 30.05.22.
//

import UIKit
import AVFAudio

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
    
    private func updateAudioPlayer() {
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: songs[currentSongIndex].localURL)
        } catch let error {
            print(error)
        }
    }

    public func playNext() {
        if currentSongIndex + 1 < songs.count {
            currentSongIndex += 1
            if self.isPlaying { self.pause() }
            updateAudioPlayer()
            self.play()
        }
    }
    
    public func playPrev() {
        if currentSongIndex - 1 > 0 {
            currentSongIndex -= 1
            if self.isPlaying { self.pause() }
            updateAudioPlayer()
            self.play()
        }
    }
    
    public func playSongAtIndex(index: Int) {
        if index >= 0 && index < songs.count {
            currentSongIndex = index
            if self.isPlaying { self.pause() }
            updateAudioPlayer()
            self.play()
        }
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
