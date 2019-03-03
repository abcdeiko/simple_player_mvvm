import Foundation
import RxSwift

protocol VideoListDataProviderProtocol {
    func getPlaylistVideos() -> Observable<[ModelYoutubeVideoInfo]>
}
