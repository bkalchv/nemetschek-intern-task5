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
    private var currentSong: Song!
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
    weak var songsDelegate: SongsDataSourceDelegate? = nil
        
    public init(withDelegate delegate: SongsDataSourceDelegate) {
        super.init()
        songsDelegate = delegate
        guard let firstSong = songsDelegate!.songs.first else { return }
        load(song: firstSong)
    }
    
    public func load(song: Song) {
        self.currentSong = song
        self.createAVAudioPlayer()
    }
    
    private func createAVAudioPlayer() {
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: self.currentSong.localURL)
        } catch let error {
            print(error)
        }
    }
        
    public func getLoadedSongDuration() -> TimeInterval {
        return audioPlayer?.duration ?? TimeInterval.zero
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
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
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
    
    private func updateAudioPlayersView() {
        self.delegate?.setMusicPlayerViewCurrentSongTitleLabel(title: currentSong.title)
        self.delegate?.setMusicPlayerViewCurrentSongRemainingLabel(remainingTimeAsString: currentSong.duration)
        self.delegate?.setMusicPlayerViewSliderMaximumValue(maximumValue: Float(getLoadedSongDuration()))
        self.delegate?.setMusicPlayerViewSliderProgress(value: 0.0)
    }
            
    private func loadNextSong() {
        if let currentIndex = self.songsDelegate?.songs.firstIndex(where: {$0 == currentSong}),
           let nextIndex = self.songsDelegate?.songs.index(after: currentIndex) {
            //TODO: handle gracefully
            guard nextIndex < self.songsDelegate!.songs.endIndex else { return }
            self.currentSong = self.songsDelegate!.songs[nextIndex]
            load(song: currentSong)
            self.updateAudioPlayersView()
        }
    }
    
    private func loadPreviousSong() {
        if let currentIndex = self.songsDelegate?.songs.firstIndex(where: {$0 == currentSong}),
           //TODO: handle gracefully
           let previousIndex = self.songsDelegate?.songs.index(before: currentIndex) {
            guard previousIndex > self.songsDelegate!.songs.index(before: self.songsDelegate!.songs.startIndex) else { return }
            self.currentSong = self.songsDelegate!.songs[previousIndex]
            load(song: currentSong)
            self.updateAudioPlayersView()
        }
    }

    public func playNextSong() {
        loadNextSong()
        if self.isPlaying { self.play() }
    }
    
    public func playPreviousSong() {
        loadPreviousSong()
        if self.isPlaying { self.play() }
    }
        
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playNextSong()
    }
    
}

