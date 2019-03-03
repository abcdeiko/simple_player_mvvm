import Foundation


class YoutubeApi: YoutubeApiProtocol {
    func getPlaylist(callback: @escaping (JSONYoutubeVideoList?, Error?) -> Void) {
        guard let apiURL = URL(string: "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50&playlistId=PLB03EA9545DD188C3&key=AIzaSyAGoC8WLQ_mh9uiXc4fPrFa4f-P37oVyks") else {
            return
        }
        
        let request = URLRequest(url: apiURL)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        let task = session.dataTask(with: request) { (data, response, networkError) in
            
            let result: JSONYoutubeVideoList?
            let error: Error?
            
            do {
                if let data = data {                    
                    result = try JSONDecoder().decode(JSONYoutubeVideoList.self, from: data)
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
