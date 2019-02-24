//
//  YoutubeDataProviderProtocol.swift
//  player
//
//  Created by Yuriy on 23/02/2019.
//  Copyright © 2019 kbshko. All rights reserved.
//

import Foundation
import RxSwift

protocol YoutubeDataProviderProtocol {
    func getPlaylistVideos() -> Observable<[ModelYoutubeVideoInfo]>
}
