//
//  JSONYoutubeVideoItem.swift
//  player
//
//  Created by Yuriy on 21/02/2019.
//  Copyright © 2019 kbshko. All rights reserved.
//

import Foundation

struct JSONYoutubeVideoItem: Codable {
    let thumbnailUrl: String?
    let title: String?
    let videoId: String
    
    enum CodingKeys: String, CodingKey {
        case snippet
        case thumbnails
        case thumbnail = "standard"
        case videoResource = "resourceId"
        
        case title
        case thumbnailUrl = "url"
        case videoId
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let snippet = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .snippet)
        let thumbnail = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .thumbnails).nestedContainer(keyedBy: CodingKeys.self, forKey: .thumbnail)
        let videoResource = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .videoResource)
        
        self.title = try snippet.decode(String.self, forKey: .title)
        self.thumbnailUrl = try thumbnail.decode(String.self, forKey: .thumbnailUrl)
        self.videoId = try videoResource.decode(String.self, forKey: .videoId)
    }
}
