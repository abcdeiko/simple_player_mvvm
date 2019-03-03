import Foundation

struct JSONYoutubeVideoList: Codable {
    let items: [JSONYoutubeVideoItem]
    
    enum CodingKeys: String, CodingKey {
        case items
    }    
}
