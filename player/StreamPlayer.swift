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

class StreamPlayer: NSObject {
    private static var playerContext = 0
    
    private lazy var currentPlayingAudio: [String: AVPlayer] = [:]
    private let _itemStatus: AnyObserver<StreamPlayerItem>
    
    let itemStatus: Observable<StreamPlayerItem>
    
    override init() {
        var statusSubject = PublishSubject<StreamPlayer>()
    //    self._itemStatus = statusSubject.asObserver()
        self.itemStatus = statusSubject.asObservable()
        
        super.init()
    }
  
    
    func playAudio(streamURL: String) -> Observable<StreamPlayerItem> {
        guard let url = URL(string: streamURL) else {
            return Observable.empty()
        }
        let playerItem = AVPlayerItem(url: url)
        
        playerItem.addObserver(
            self,
            forKeyPath: #keyPath(AVPlayerItem.status),
            options: [.new], context: &StreamPlayer.playerContext)
        
        let newPlayer = AVPlayer(playerItem: playerItem)
        newPlayer.play()
        
        self.currentPlayingAudio[streamURL] = newPlayer
        
        
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
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard context == &StreamPlayer.playerContext,
            let playerItem = object as? AVPlayerItem,
            let url = (playerItem.asset as? AVURLAsset)?.url else {
                
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
            return
        }
        
        print("player item \(url)")
        
            
        switch playerItem.status {
        case .readyToPlay:
            print("player item playing")
        case .failed:
            print("player item Failed")
        case .unknown:
            print("player item Unknown")
        }
    }
}
