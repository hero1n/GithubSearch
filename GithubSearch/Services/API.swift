//
//  API.swift
//  GithubSearch
//
//  Created by jaewon on 2020/04/11.
//  Copyright © 2020 jaewon. All rights reserved.
//

import Foundation
import Alamofire

enum API {
    case getUsers(query: String, page: Int)
    case getSingleUser(userName: String)
}

extension API {
    var method: HTTPMethod {
        switch self {
        case .getUsers, .getSingleUser: return .get
        }
    }
    
    var url: URLConvertible {
        switch self {
        case .getUsers: return "\(URLConstants.BASE_URL)/search/users"
        case .getSingleUser(let userName): return "\(URLConstants.BASE_URL)/users/\(userName)"
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .getUsers(let query, let page):
            return ["q": "\(query)", "page": "\(page)", "per_page": "20"]
        default:
            return [:]
        }
    }
}
