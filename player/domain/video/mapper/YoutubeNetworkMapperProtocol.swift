//
//  YoutubeNetworkMapperProtocol.swift
//  player
//
//  Created by Yuriy on 23/02/2019.
//  Copyright © 2019 kbshko. All rights reserved.
//

import Foundation

protocol YoutubeNetworkMapperProtocol {
    func map(_ list: JSONYoutubeVideoList) -> [ModelYoutubeVideoInfo]
}
