import Foundation
import RxSwift

class VideoListDataProvider: VideoListDataProviderProtocol {
    
    private let networkSource: YoutubeApiProtocol
    private let mapper: YoutubeNetworkMapperProtocol
    
    init(networkSource: YoutubeApiProtocol, mapper: YoutubeNetworkMapperProtocol) {
        self.networkSource = networkSource
        self.mapper = mapper
    }
    
    func getPlaylistVideos() -> Observable<[ModelYoutubeVideoInfo]> {
        return Observable.create({ (observer) -> Disposable in
            
            self.networkSource.getPlaylist(callback: { (list, error) in
                if let error = error {
                    observer.onError(error)
                }
                
                if let list = list {
                    observer.onNext(self.mapper.map(list))
                }
                
                observer.onCompleted()
            })
            
            return Disposables.create()
        })
    }
}
