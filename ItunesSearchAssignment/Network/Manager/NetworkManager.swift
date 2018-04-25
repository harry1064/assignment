//
//  NetworkManager.swift
//  ItunesSearchAssignment
//  Copyright © 2018 HarpreetSingh. All rights reserved.
//

import Foundation


enum NetworkResponse: String {
    case success
    case badRequest = "Bad Request"
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode"
    case unableToDecode = "Could not decode response"
}

enum Result<String> {
    case success
    case failure(String)
}




struct NetworkManager {
    private let musicRouter =  Router<MusicSearchApi>()
    
    
    fileprivate func handleNetworkResponse (_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299: return .success
        case 401...599: return .failure(NetworkResponse.badRequest.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
    
    
    func getMusic(query: String, completion: @escaping (_ musics: [Music]?, _ error: String?) -> ()) {
        musicRouter.request(.music(query: query)) { (data, response, error) in
            if let error = error {
                completion(nil, error.localizedDescription)
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data  else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(MusicSearchApiResponse.self, from: responseData)
                        completion(apiResponse.musics, nil)
                    } catch {
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
            
        }
    }
    
}
