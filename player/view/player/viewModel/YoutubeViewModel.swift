import Foundation
import RxSwift
import AVFoundation

enum YoutuveViewControlTag: Int {
    case play
    case stop
}

class YoutubeViewModel {
    
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
        
        _tapControl.asObservable()
        .do(onNext: <#T##((Int?) throws -> Void)?##((Int?) throws -> Void)?##(Int?) throws -> Void#>
        
        self.controlTag = _controlTag.asObservable()
        
        //todo проброс ошибок
        //player.itemStatus.
        
    }
}
