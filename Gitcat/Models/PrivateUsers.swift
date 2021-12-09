//
//  PrivateUsers.swift
//  Gitcat
//
//  Created by Hanan Ibrahim on 07/12/2021.
//

enum PrivateUser: CustomStringConvertible {
    
    case userName
    case userAvatar
    case userFollowers
    case userFollowing
    case userBio
    case userLoginName
    case userLocation
    case userReposCount
    case userStarttedCount
    case userOrgsCount
    case userID
    
    var description: String {
        switch self {
        case .userName :
            return "name"
        case .userAvatar:
            return "avatar_url"
        case .userFollowers:
            return "followers"
        case .userFollowing:
            return "following"
        case .userBio:
            return "bio"
        case .userLoginName:
            return "login"
        case .userLocation:
            return "location"
        case .userReposCount:
             return "location"
        case .userStarttedCount:
           return "location"
        case .userOrgsCount:
             return "location"
        case .userID:
             return "id"
        }
    }

}
