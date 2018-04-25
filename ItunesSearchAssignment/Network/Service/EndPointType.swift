//
//  EndPointType.swift
//  ItunesSearchAssignment
//  Copyright © 2018 HarpreetSingh. All rights reserved.
//

import Foundation

protocol EndPointType {
    var baseUrl: URL {get}
    var path: String {get}
    var httpMethod: HTTPMethod {get}
    var task: HTTPTask {get}
    var headers: HTTPHeaders? {get}
}
