//
//  YoutubeVideoProviderProtocol.swift
//  player
//
//  Created by Yuriy on 03/03/2019.
//  Copyright © 2019 kbshko. All rights reserved.
//

import Foundation
import RxSwift

protocol YoutubeVideoProviderProtocol {
    func getStreamUrlFor(videoId: String) -> Observable<URL>
}
