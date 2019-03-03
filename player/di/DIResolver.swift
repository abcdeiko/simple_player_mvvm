import Foundation

typealias Resolver = VideoListDIResolver & AudiolistDIResolver & YoutubeDIResolver

protocol VideoListDIResolver {
    func videoListView() -> BaseViewController
    func videoListViewModel() -> VideoListViewModel
}

protocol AudiolistDIResolver {
    func audioListView() -> BaseViewController
    func audioListViewModel() -> AudioListViewModel
}

protocol YoutubeDIResolver {
    func youtubePlayerView(videoId: String) -> BaseViewController
    func youtubePlayerViewModel() -> YoutubeViewModel
}

class DIResolver {
    
    private lazy var player = StreamPlayer()
    
    func inject(_ vc: BaseViewController) {
        vc.diResolver = self
    }
}

extension DIResolver: VideoListDIResolver {
    func videoListView() -> BaseViewController {
        let vc = VideoViewController(nibName: "VideoViewController", bundle: nil)
        vc.diResolver = self
        
        return vc
    }
    
    func videoListViewModel() -> VideoListViewModel {
        return VideoListViewModel(
            videoListProvider: VideoListDataProvider(
                networkSource: YoutubeApi(),
                mapper: YoutubeNetworkMapper()
            ),
            viewModelMapper: VideoListViewModelMapper()
        )
    }
}

extension DIResolver: AudiolistDIResolver {
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

extension DIResolver: YoutubeDIResolver {
    func youtubePlayerView(videoId: String) -> BaseViewController {
        let vc = YoutubePlayerViewController(nibName: "YoutubePlayerViewController", bundle: nil)
        vc.diResolver = self
        vc.videoId = videoId
        
        return vc
    }
    
    func youtubePlayerViewModel() -> YoutubeViewModel {
        return YoutubeViewModel(
            player: self.player,
            videoProvider: YoutubeVideoProvider()
        )
    }
}
