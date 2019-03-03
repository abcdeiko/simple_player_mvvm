//
//  YoutubeVideoProvider.swift
//  player
//
//  Created by Yuriy on 03/03/2019.
//  Copyright © 2019 kbshko. All rights reserved.
//

import Foundation
import RxSwift
import XCDYouTubeKit

class YoutubeVideoProvider: YoutubeVideoProviderProtocol {
    func getStreamUrlFor(videoId: String) -> Observable<URL> {
        
        return Observable.create({ observer in
            XCDYouTubeClient.default().getVideoWithIdentifier(videoId) { (video, error) in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let streamUrl = video?.streamURLs[XCDYouTubeVideoQuality.medium360.rawValue] else {
                    observer.onCompleted()
                    return
                }
                
                observer.onNext(streamUrl)
                observer.onCompleted()
            }
            
            return Disposables.create()
        })
    }
}
