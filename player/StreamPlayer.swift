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
    private let itemStatusSubject: PublishSubject<StreamPlayerItem>
    
    var itemStatus: Observable<StreamPlayerItem> {
        get { return self.itemStatusSubject.asObserver() }
    }
    
    override init() {
        self.itemStatusSubject = PublishSubject<StreamPlayerItem>()
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
        
        // если не получилось проиграть, то убираем из списка проигрываемых
        if playerItem.status == .failed {
            self.currentPlayingAudio.removeValue(forKey: url.absoluteString)
        }
        
        // формируем и отправляем информацию о новом статусе проигрываемого элемента
        let statusItem = StreamPlayerItem(url: url.absoluteString, state: playerItem.status == .failed ? .stopped: .playing)
        
        self.itemStatusSubject.onNext(statusItem)
    }
}
