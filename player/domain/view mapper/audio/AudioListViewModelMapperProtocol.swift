//
//  AudioListViewModelMapperProtocol.swift
//  player
//
//  Created by Yuriy on 24/02/2019.
//  Copyright © 2019 kbshko. All rights reserved.
//

import Foundation

protocol AudioListViewModelMapperProtocol {
    func map(_ items: [RadioStreamModel]) -> [AudioItemViewModel]
}
