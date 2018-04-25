//
//  MusicSearchEndPoint.swift
//  ItunesSearchAssignment
//  Copyright © 2018 HarpreetSingh. All rights reserved.
//

import Foundation

public enum MusicSearchApi {
    case music(query: String)
}

extension MusicSearchApi: EndPointType {
    
    var baseUrl: URL {
        guard let url = URL(string: "https://itunes.apple.com/search") else {
            fatalError()
        }
        return url
    }
    
    var path: String {
        switch self {
        case .music:
            return "/"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .music:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .music(let query):
            return .requestParameters(bodyParameters: nil, urlParameters: [
                "term": query,
                "media": "music"
                ])
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    
}
