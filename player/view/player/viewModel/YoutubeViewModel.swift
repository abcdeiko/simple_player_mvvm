import Foundation
import RxSwift
import AVFoundation

class YoutubeViewModel {
    
    //MARK: - Input
    let playVideo: AnyObserver<String>
    
    let stopVideo: AnyObserver<Void>
    
    //MARK: - Output
    let showVideoLayer: Observable<AVPlayerLayer>
    
    let close: Observable<Void>
    
    init(player: StreamPlayer, videoProvider: YoutubeVideoProviderProtocol) {
        let _playVideo = PublishSubject<String>()
        let _stopVideo = PublishSubject<Void>()
        
        self.playVideo = _playVideo.asObserver()
        self.stopVideo = _stopVideo.asObserver()
        
        self.showVideoLayer = _playVideo
            .do(onNext: { (_) in player.stopAll() })
            .flatMap{ videoProvider.getStreamUrlFor(videoId: $0) }
            .flatMap{ player.play(streamURL: $0.absoluteString) }
            .map{ AVPlayerLayer(player: $0.player) }
        
        self.close = _stopVideo
            .asObservable()
            .do(onNext: { player.stopAll() })        
    }
}
