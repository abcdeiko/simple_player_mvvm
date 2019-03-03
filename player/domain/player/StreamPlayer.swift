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
    let player: AVPlayer
    
    init(url: String, state: StreamPlayerState, player: AVPlayer) {
        self.url = url
        self.state = state
        self.player = player
    }
}

class StreamPlayer: NSObject {
    private static var playerContext = 0
    
    private lazy var currentPlayingItems: [String: AVPlayer] = [:]
    private let itemStatusSubject: PublishSubject<StreamPlayerItem>
    
    var itemStatus: Observable<StreamPlayerItem> {
        get { return self.itemStatusSubject.asObserver() }
    }
    
    override init() {
        self.itemStatusSubject = PublishSubject<StreamPlayerItem>()
        super.init()
    }
    
    func play(streamURL: String) -> Observable<StreamPlayerItem> {
        guard let url = URL(string: streamURL) else {
            return Observable.empty()
        }
        
        let playerItem = AVPlayerItem(url: url)
        
        // отслеживаем состояние
        self.observePlayerItem(playerItem)
        
        let newPlayer = AVPlayer(playerItem: playerItem)
        newPlayer.play()
        
        self.currentPlayingItems[streamURL] = newPlayer
        
        let playerStateItem = StreamPlayerItem(
            url: streamURL,
            state: newPlayer.status == .failed ? .stopped: .playing,
            player: newPlayer
        )
        
        return Observable.just(playerStateItem)
    }
    
    func stop(streamURL: String) -> Observable<StreamPlayerItem> {
        guard let player = self.currentPlayingItems[streamURL] else {
            return Observable.empty()
        }
        
        player.pause()
        player.replaceCurrentItem(with: nil)
        
        self.currentPlayingItems.removeValue(forKey: streamURL)
      
        return Observable.create {
            let result = StreamPlayerItem(
                url: streamURL,
                state: .stopped,
                player: player
            )
            
            $0.onNext(result)
            
            return Disposables.create()
        }
    }
    
    func stopAll() {
        self.currentPlayingItems.forEach { (_, currentPlayer) in
            currentPlayer.pause()
            currentPlayer.replaceCurrentItem(with: nil)
        }
        
        self.currentPlayingItems.removeAll()
    }
    
    func getPlayingItems() -> [StreamPlayerItem] {
        let items = self.currentPlayingItems.map {
            StreamPlayerItem(url: $0.key, state: .playing, player: $0.value)
        }
        
        return items
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard context == &StreamPlayer.playerContext,
            let playerItem = object as? AVPlayerItem,
            let url = (playerItem.asset as? AVURLAsset)?.url,
            let player = self.currentPlayingItems[url.absoluteString] else {
                
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
            return
        }
        
        // если не получилось проиграть, то убираем из списка проигрываемых
        if playerItem.status == .failed {
            self.currentPlayingItems.removeValue(forKey: url.absoluteString)
            playerItem.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), context: context)
        }
        
        // формируем и отправляем информацию о новом статусе проигрываемого элемента
        let statusItem = StreamPlayerItem(
            url: url.absoluteString,
            state: playerItem.status == .failed ? .stopped: .playing, player: player)
        
        self.itemStatusSubject.onNext(statusItem)
    }
    
    private func createPlayerItemFrom(from: URL) -> AVPlayerItem {
        let playerItem = AVPlayerItem(url: from)
        self.observePlayerItem(playerItem)
        
        return playerItem
    }
    
    private func observePlayerItem(_ item: AVPlayerItem) {
        item.addObserver(
            self,
            forKeyPath: #keyPath(AVPlayerItem.status),
            options: [.new],
            context: &StreamPlayer.playerContext
        )
    }
}
