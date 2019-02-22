//
//  YoutubeApi.swift
//  player
//
//  Created by Yuriy on 20/02/2019.
//  Copyright © 2019 kbshko. All rights reserved.
//

import Foundation


class YoutubeApi {
    func getPlaylist(callback: @escaping (JSONYoutubeVideoItem?, Error?) -> Void) {
        guard let apiURL = URL(string: "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50&playlistId=PL6gx4Cwl9DGBsvRxJJOzG4r4k_zLKrnxl&key=AIzaSyAGoC8WLQ_mh9uiXc4fPrFa4f-P37oVyks") else {
            return
        }
        
        let request = URLRequest(url: apiURL)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        let task = session.dataTask(with: request) { (data, response, networkError) in
            
            let result: [JSONYoutubeVideoItem]?
            let error: Error?
            
            do {
                if let data = data {
                    JSONDecoder.decode(<#T##JSONDecoder#>)
                    result = try JSONDecoder().decode(JSONYoutubeVideoItem.self, from: data)
                } else {
                    result = nil
                }
                
                error = networkError
            } catch let parseError {
                error = parseError
                result = nil
            }
            
            callback(result, error)
        }
        
        task.resume()
    }
}
