//
//  UsersModel.swift
//  Gitcat
//
//  Created by Ali Fayed on 07/12/2021.
//

import Foundation
//struct UsersModel: Decodable {
//    let login: String
//    let html_url: String
//    let avatar_url: String
//}
struct UsersModel {
    let userName: String
    let userURL: String
    let userAvatar: String
    
    enum UsersCodingKeys: String, CodingKey {
        case userName = "login"
        case userURL = "html_url"
        case userAvatar = "avatar_url"
    }
}
extension UsersModel: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UsersCodingKeys.self)
        userName = try container.decode(String.self, forKey: .userName)
        userURL = try container.decode(String.self, forKey: .userURL)
        userAvatar = try container.decode(String.self, forKey: .userAvatar)
    }
}
