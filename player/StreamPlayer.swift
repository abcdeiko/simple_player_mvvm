//
//  StreamPlayer.swift
//  player
//
//  Created by Yuriy on 17/02/2019.
//  Copyright © 2019 kbshko. All rights reserved.
//

import Foundation
import AVFoundation
import RxSwift

enum StreamPlayerState {
    case playing
    case stopped
}

class StreamPlayerItem {
    let url: String
    let state: StreamPlayerState
    
    init(url: String, state: StreamPlayerState) {
        self.url = url
        self.state = state
    }
}

class StreamPlayer {
    private lazy var currentPlayingAudio: [String: AVPlayer] = [:]
    
    init() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(playedFinishedWithError(_:)),
            name: NSNotification.Name.AVPlayerItemFailedToPlayToEndTime,
            object: nil
        )
    }
    
    func playAudio(streamURL: String) -> Observable<StreamPlayerItem> {
        guard let url = URL(string: streamURL) else {
            return Observable.empty()
        }
        
        let newPlayer = AVPlayer(url: url)
        self.currentPlayingAudio[streamURL] = newPlayer
        newPlayer.play()
        
        return Observable.create {
            let result = StreamPlayerItem(url: streamURL, state: newPlayer.status == .failed ? .stopped: .playing)
            
            $0.onNext(result)
            
            return Disposables.create()
        }
    }
    
    func stopAudio(streamURL: String) -> Observable<StreamPlayerItem> {
        guard let player = self.currentPlayingAudio[streamURL] else {
            return Observable.empty()
        }
        
        player.pause()
        
        self.currentPlayingAudio.removeValue(forKey: streamURL)
      
        return Observable.create {
            let result = StreamPlayerItem(url: streamURL, state: .stopped)
            
            $0.onNext(result)
            
            return Disposables.create()
        }
    }
    
    func getPlayingItems() -> [StreamPlayerItem] {
        let items = self.currentPlayingAudio.map {
            StreamPlayerItem(url: $0.key, state: .playing)
        }
        
        return items
    }
    
    @objc func playedFinishedWithError(_ sender: AnyObject) {
        print("adf")
    }
}
