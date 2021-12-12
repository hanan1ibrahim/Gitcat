//
//  Following.swift
//  Gitcat
//
//  Created by Ali Fayed on 12/12/2021.
//

import Foundation

struct Following {
    let userName: String
    let userURL: String
    let userAvatar: String
    
    enum FollowingCodingKeys: String, CodingKey {
        case userName = "login"
        case userURL = "html_url"
        case userAvatar = "avatar_url"
    }
}
extension Following: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: FollowingCodingKeys.self)
        userName = try container.decode(String.self, forKey: .userName)
        userURL = try container.decode(String.self, forKey: .userURL)
        userAvatar = try container.decode(String.self, forKey: .userAvatar)
    }
}
