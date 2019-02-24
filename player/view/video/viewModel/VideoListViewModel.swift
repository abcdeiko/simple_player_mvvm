import Foundation
import RxSwift
import RxCocoa

class VideoListViewModel {
    //MARK: - Input
    let reload: AnyObserver<Void>
    
    let selectVideo: AnyObserver<VideoItemViewModel>
    
    //MARK: - Output
    let videos: Observable<[VideoItemViewModel]>
    
    let showVideoById: Observable<String>
    
    
    init(videoListProvider: YoutubeDataProviderProtocol, viewModelMapper: VideoListViewModelMapperProtocol) {
        let _reload = PublishSubject<Void>()
        self.reload = _reload.asObserver()
        
        // загружаем список видео и конвертируем в нужную viewModel
        self.videos = _reload
            .flatMap { videoListProvider.getPlaylistVideos() }
            .map { viewModelMapper.map($0) }
        
        let _selectVideo = PublishSubject<VideoItemViewModel>()
        self.selectVideo = _selectVideo.asObserver()
        
        self.showVideoById = _selectVideo.asObservable()
            .map { $0.videoId }        
    }
}
