//
//  AudioListViewModel.swift
//  player
//
//  Created by Yuriy on 24/02/2019.
//  Copyright © 2019 kbshko. All rights reserved.
//

import Foundation
import RxSwift

class AudioListViewModel {
    
    //MARK: Input
    let reload: AnyObserver<Void>
    
    let selected: AnyObserver<AudioItemViewModel>
    
    //MARK: Output
    let radioStreams: Observable<[AudioItemViewModel]>
    
    init(radioListProvider: RadioStreamsProviderProtocol, viewModelMapper: AudioListViewModelMapperProtocol) {
        let _reload = PublishSubject<Void>()
        self.reload = _reload.asObserver()
        self.radioStreams = _reload
            .flatMapLatest { radioListProvider.getAudioList() }
            .map { viewModelMapper.map($0) }
        
        let _selected = PublishSubject<AudioItemViewModel>()
        self.selected = _selected.asObserver()
        
        //_selected.s
    }
}
