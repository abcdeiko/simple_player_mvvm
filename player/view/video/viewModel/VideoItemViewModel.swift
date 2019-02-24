import Foundation

class VideoItemViewModel {
    let thumbnailUrl: String?
    let title: String?
    let videoId: String
    
    init(title: String?, thumbnailUrl: String?, videoId: String) {
        self.thumbnailUrl = thumbnailUrl
        self.title = title
        self.videoId = videoId
    }
}
