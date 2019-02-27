import Foundation
import RxSwift

class AudioListViewModel {
    //MARK: Input
    let reload: AnyObserver<Void>
    
    let selected: AnyObserver<AudioItemViewModel>
    
    //MARK: Output
    let radioStreams: Observable<[AudioItemViewModel]>
    
    
    init(radioListProvider: RadioStreamsProviderProtocol, viewModelMapper: AudioListViewModelMapperProtocol, player: StreamPlayer) {
        let _reload = PublishSubject<Void>()
        self.reload = _reload.asObserver()
        
        weak var weakPlayer = player
        
        // подписываемся на событие перезагрузки
        self.radioStreams = _reload
            .asObservable()            
            .flatMapLatest { radioListProvider.getAudioList() }
            .map {
                let viewModels = viewModelMapper.map($0)
                let playingItems = weakPlayer?.getPlayingItems()
                
                return viewModels.map { (viewModel) in
                    viewModel.playing = playingItems?.contains { $0.url == viewModel.url } ?? false
                    
                    return viewModel
                }
        }
        
        let _selected = PublishSubject<AudioItemViewModel>()
        self.selected = _selected.asObserver()
        
        // подписываемся на событие клика по ячейке
        let _ = _selected.asObservable()
            .flatMap {
                ($0.playing ? weakPlayer?.stopAudio(streamURL: $0.url): weakPlayer?.playAudio(streamURL: $0.url)) ?? Observable.empty()
            }
            .subscribe(onNext: { (_) in  _reload.onNext(()) })
    }
}
