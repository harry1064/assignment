//
//  MusicModel.swift
//  ItunesSearchAssignment
//  Copyright © 2018 HarpreetSingh. All rights reserved.
//

import Foundation

struct MusicSearchApiResponse {
    let resultCount: Int
    let musics: [Music]
}

extension MusicSearchApiResponse: Decodable {
    
    private enum MusicSearchApiCodingKeys: String, CodingKey {
        case resultCount
        case musics = "results"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MusicSearchApiCodingKeys.self)
        
        resultCount = try container.decode(Int.self, forKey: .resultCount)
        musics = try container.decode([Music].self, forKey: .musics)
    }
}


struct Music: Codable {
    let artistId: Int
    let collectionId: Int
    let trackId: Int
    let artistName: String
    let trackName: String
    let previewUrl: String
    let artworkUrl60: String
}
