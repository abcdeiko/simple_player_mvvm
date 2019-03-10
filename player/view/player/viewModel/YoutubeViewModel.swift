import Foundation
import RxSwift
import AVFoundation

enum YoutuveViewControlTag: Int {
    case play
    case stop
}

class YoutubeViewModel {
    
    private var videoUrl: String?
    
    //MARK: - Input
    let playVideo: AnyObserver<String>
    
    let tapCloseVideo: AnyObserver<Void>
    
    let tapView: AnyObserver<Void>
    
    let tapControl: AnyObserver<Int?>
    
    //MARK: - Output
    let videoLayer: Observable<AVPlayerLayer>
    
    let close: Observable<Void>
    
    let controlTag: Observable<YoutuveViewControlTag>
    
    
    init(player: StreamPlayer, videoProvider: YoutubeVideoProviderProtocol) {
        let _playVideo = PublishSubject<String>()
        let _tapCloseVideo = PublishSubject<Void>()
        let _tapView = PublishSubject<Void>()
        let _tapControl = PublishSubject<Int?>()
        let _controlTag = PublishSubject<YoutuveViewControlTag>()
        
        self.playVideo = _playVideo.asObserver()
        self.tapCloseVideo = _tapCloseVideo.asObserver()
        self.tapView = _tapView.asObserver()
        self.tapControl = _tapControl.asObserver()
        
        self.videoLayer = _playVideo
            .do(onNext: { (_) in
                _controlTag.onNext(.stop)
                player.stopAll()
            })
            .flatMap{ videoProvider.getStreamUrlFor(videoId: $0) }
            .flatMap{ player.play(streamURL: $0.absoluteString) }
            .do(onNext: { _controlTag.onNext($0.state != .playing ? .stop: .play) })
            .map{ AVPlayerLayer(player: $0.player) }
        
        // создаем издателя для действия закрытия
        self.close = _tapCloseVideo
            .asObservable()
            .do(onNext: { player.stopAll() })
        
        self.controlTag = _tapControl.asObservable()
            .map { (t) -> YoutuveViewControlTag in
                guard let tag = t else { return YoutuveViewControlTag.play }
                return YoutuveViewControlTag(rawValue: tag) ?? YoutuveViewControlTag.play
            }
            .do(onNext: {
               // $0 == .play ? player.stopAll(): player.play(streamURL: <#T##String#>)
            })
            .map {
                return $0 == .stop ? .play: .stop
        }
        
        //todo проброс ошибок
        //player.itemStatus.
        
    }
}
