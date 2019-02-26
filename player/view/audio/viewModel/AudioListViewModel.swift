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
        
        // подписываемся на событие перезагрузки
        self.radioStreams = _reload
            .asObservable()            
            .flatMapLatest { radioListProvider.getAudioList() }
            .concat(<#T##second: ObservableConvertibleType##ObservableConvertibleType#>)
        
            //.map { viewModelMapper.map($0) }
        
        let _selected = PublishSubject<AudioItemViewModel>()
        self.selected = _selected.asObserver()
        
        weak var weakPlayer = player
        
        // подписываемся на событие клика по ячейке
        let _ = _selected.asObservable()
            .flatMap { weakPlayer?.playAudio(streamURL: $0.url) ?? Observable.empty() }
            .subscribe(onNext: { [weak self] (_) in
                self?.reload.onNext(())
            })
    }
}
