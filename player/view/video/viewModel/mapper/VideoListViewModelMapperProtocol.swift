import Foundation

protocol VideoListViewModelMapperProtocol {
    func map(_ items: [ModelYoutubeVideoInfo]) -> [VideoItemViewModel]
}
