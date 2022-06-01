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
    func setMusicPlayerViewCurrentSongRemainingLabel(remainingTimeAsString: String)
    func setMusicPlayerViewSliderMaximumValue(maximumValue: Float)
    func setMusicPlayerViewSliderProgress(value: Float)
}

class AudioPlayer: NSObject, AVAudioPlayerDelegate {
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
        super.init()
        if !songs.isEmpty {
            self.songs = songs
            setupAudioPlayer(song: songs.first!)
        }
    }
    
    public func getCurrentSong() -> Song {
        return songs[currentSongIndex]
    }
    
    public func getLoadedSongDuration() -> TimeInterval {
        return audioPlayer!.duration
    }
    
    private func setupAudioPlayer(song: Song) {
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: song.localURL)
        } catch let error {
            print(error)
        }
    }
    
    private func formatRemainingTime(remainingTime: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        var remainingTimeAsString = formatter.string(from: remainingTime)!
        if remainingTime < 60 {
            remainingTimeAsString = "0:\(remainingTimeAsString)"
        }
        remainingTimeAsString = "-\(remainingTimeAsString)"
        return remainingTimeAsString
    }
    
    @objc private func updateProgress() {
        self.delegate?.setMusicPlayerViewSliderProgress(value: Float(self.audioPlayer!.currentTime))
        let remainingTime = self.audioPlayer!.duration - self.audioPlayer!.currentTime
        let remainingTimeAsString = formatRemainingTime(remainingTime: remainingTime)
        self.delegate?.setMusicPlayerViewCurrentSongRemainingLabel(remainingTimeAsString:remainingTimeAsString)
    }
    
    public func play() {
        
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        }
        
        if let audioPlayer = audioPlayer {
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }
    }
    
    public func pause() {
        timer?.invalidate()
        timer = nil
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
        self.delegate?.setMusicPlayerViewCurrentSongRemainingLabel(remainingTimeAsString: currentSong.duration)
        self.delegate?.setMusicPlayerViewSliderMaximumValue(maximumValue: Float(getLoadedSongDuration()))
        self.delegate?.setMusicPlayerViewSliderProgress(value: 0.0)
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
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playNextSong()
    }
    
}

