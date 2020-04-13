//
//  GithubSearch.swift
//  GithubSearch
//
//  Created by jaewon on 2020/04/11.
//  Copyright © 2020 jaewon. All rights reserved.
//

import Foundation
import ObjectMapper

class GithubSearchModel {
    class UserList: Mappable {
        var totalCount: Int?
        var items: [UserItem]?
        
        required init?(map: Map) {
            
        }
        
        func mapping(map: Map) {
            self.totalCount <- map["total_count"]
            self.items <- map["items"]
        }
    }
    
    class UserItem: Mappable {
        var id: Int?
        var userName: String?
        var avatarURL: String?
        
        required init?(map: Map) {
            
        }
        
        func mapping(map: Map) {
            self.id <- map["id"]
            self.userName <- map["login"]
            self.avatarURL <- map["avatar_url"]
        }
    }
    
    class UserDetail: Mappable {
        var id: Int?
        var repoCount: Int?
        
        required init?(map: Map) {
            
        }
        
        func mapping(map: Map) {
            self.id <- map["id"]
            self.repoCount <- map["public_repos"]
        }
    }
    
    class User {
        var id: Int?
        var avatarURL: String?
        var userName: String?
        var repoCount: Int?
        
        init(user: UserItem) {
            self.id = user.id
            self.avatarURL = user.avatarURL
            self.userName = user.userName
        }
    }
}
