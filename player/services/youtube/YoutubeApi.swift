//
//  YoutubeApi.swift
//  player
//
//  Created by Yuriy on 20/02/2019.
//  Copyright © 2019 kbshko. All rights reserved.
//

import Foundation


class YoutubeApi {
    func get() {
        let apiURL = URL(string: "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50&playlistId=PL6gx4Cwl9DGBsvRxJJOzG4r4k_zLKrnxl&key=AIzaSyAGoC8WLQ_mh9uiXc4fPrFa4f-P37oVyks")
        
        
//        let endpoint = Todo.endpointForID(id)
//        guard let url = NSURL(string: endpoint) else {
//            print("Error: cannot create URL")
//            let error = NSError(domain: "TodoClass", code: 1, userInfo: [NSLocalizedDescriptionKey: "cannot create URL"])
//            completionHandler(nil, error)
//            return
//        }
//        let urlRequest = NSURLRequest(URL: url)
//
//        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
//        let session = NSURLSession(configuration: config)
//
//        let task = session.dataTaskWithRequest(urlRequest, completionHandler: {
//            (data, response, error) in
//            guard let responseData = data else {
//                print("Error: did not receive data")
//                completionHandler(nil, error)
//                return
//            }
//            guard error == nil else {
//                print("error calling GET on /todos/1")
//                print(error)
//                completionHandler(nil, error)
//                return
//            }
//            // parse the result as JSON, since that's what the API provides
//            do {
//                if let todoJSON = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [String: AnyObject] {
//                    if let todo = Todo(json: todoJSON) {
//                        // created a TODO object
//                        completionHandler(todo, nil)
//                    } else {
//                        // couldn't create a todo object from the JSON
//                        let error = NSError(domain: "TodoClass", code: 3, userInfo: [NSLocalizedDescriptionKey: "Couldn't create a todo object from the JSON"])
//                        completionHandler(nil, error)
//                    }
//                }
//            } catch  {
//                print("error trying to convert data to JSON")
//                let error = NSError(domain: "TodoClass", code: 2, userInfo: [NSLocalizedDescriptionKey: "error trying to convert data to JSON"])
//                completionHandler(nil, error)
//                return
//            }
//        })
//        task.resume()
        
    }
}
