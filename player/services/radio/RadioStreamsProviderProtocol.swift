//
//  RadioStreamsProviderProtocol.swift
//  player
//
//  Created by Yuriy on 24/02/2019.
//  Copyright © 2019 kbshko. All rights reserved.
//

import Foundation
import RxSwift

protocol RadioStreamsProviderProtocol {
    func getAudioList() -> Observable<[RadioStreamModel]>
}
