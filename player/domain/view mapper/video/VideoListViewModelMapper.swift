import Foundation

class VideoListViewModelMapper: VideoListViewModelMapperProtocol {
    func map(_ items: [ModelYoutubeVideoInfo]) -> [VideoItemViewModel]  {
        return items.map { VideoItemViewModel(title: $0.title, thumbnailUrl: $0.thumbnailUrl, videoId: $0.videoId) }
    }
}
