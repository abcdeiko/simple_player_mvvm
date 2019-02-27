import Foundation

typealias Resolver = VideoListDIResolver & AudiolistDIResolver

protocol VideoListDIResolver {
    func videoListView() -> BaseViewController
    func videoListViewModel() -> VideoListViewModel
}

protocol AudiolistDIResolver {
    func audioListView() -> BaseViewController
    func audioListViewModel() -> AudioListViewModel
}

class DIResolver: Resolver {
    
    private lazy var player = StreamPlayer()
    
    func inject(_ vc: BaseViewController) {
        vc.diResolver = self
    }
    
    func videoListView() -> BaseViewController {
        let vc = VideoViewController(nibName: "VideoViewController", bundle: nil)
        vc.diResolver = self
        
        return vc
    }
    
    func videoListViewModel() -> VideoListViewModel {
        return VideoListViewModel(
            videoListProvider: YoutubeDataProvider(
                networkSource: YoutubeApi(),
                mapper: YoutubeNetworkMapper()
            ),
            viewModelMapper: VideoListViewModelMapper()
        )
    }
    
    func audioListView() -> BaseViewController {
        let vc = AudioViewController(nibName: "AudioViewController", bundle: nil)
        vc.diResolver = self
        
        return vc
    }
    
    func audioListViewModel() -> AudioListViewModel {
        return AudioListViewModel(
            radioListProvider: RadioStreamsProvider(),
            viewModelMapper: AudioListViewModelMapper(),
            player: self.player
        )
    }
}