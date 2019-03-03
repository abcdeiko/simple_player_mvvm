import Foundation

protocol YoutubeApiProtocol {
    func getPlaylist(callback: @escaping (JSONYoutubeVideoList?, Error?) -> Void)
}
