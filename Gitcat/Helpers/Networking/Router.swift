//
//  Router.swift
//  Gitcat
//
//  Created by Hanan Ibrahim on 07/12/2021.
//


import Alamofire

enum Router {
    case usersListAPIlink(String)
    case repositoryAPIlink(String)
    case accessTokenAPIlink(String)
    case privateUserAPIlink
    case privateUserFollowListAPIlink
    case privateUserUnfollowAPIlink(user: String)
    case privateUserFollowAPILink(user: String)
    
    var baseURL: String {
        switch self {
        case .usersListAPIlink:
            return "https://api.github.com"
        case .repositoryAPIlink:
            return "https://api.github.com"
        case .accessTokenAPIlink:
            return "https://github.com"
        case .privateUserAPIlink:
            return "https://api.github.com"
        case .privateUserFollowListAPIlink:
            return "https://api.github.com"
        case .privateUserUnfollowAPIlink:
            return "https://api.github.com"
        case .privateUserFollowAPILink:
            return "https://api.github.com"
        }
    }
    
    var path: String {
        switch self {
        case .usersListAPIlink:
            return "/search/users"
        case .repositoryAPIlink:
            return "/search/repositories"
        case .accessTokenAPIlink:
            return "/login/oauth/access_token"
        case .privateUserAPIlink:
            return "/user"
        case .privateUserFollowListAPIlink:
            return "/user/following"
        case .privateUserUnfollowAPIlink(let user):
            return "/user/following/\(user)"
        case .privateUserFollowAPILink(let user):
            return "/user/following/\(user)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .usersListAPIlink:
            return .get
        case .repositoryAPIlink:
            return .get
        case .accessTokenAPIlink:
            return .post
        case .privateUserAPIlink:
            return .get
        case .privateUserFollowListAPIlink:
            return .get
        case .privateUserUnfollowAPIlink:
            return .delete
        case .privateUserFollowAPILink:
            return .put
        }
    }
    
    var parameters: [String: String]? {
        switch self {
        case .usersListAPIlink(let query):
            return ["per_page": "30" ,"sort": "repositories", "order": "desc", "q": query]
        case .repositoryAPIlink(let query):
            return ["per_page": "30", "sort": "stars", "order": "desc", "q": query]
        case .accessTokenAPIlink(let accessToken):
            return [
                "client_id": Constants.clientID,
                "client_secret": Constants.clientSecret,
                "code": accessToken
            ]
        case .privateUserAPIlink:
           return nil
        case .privateUserFollowListAPIlink:
            return ["per_page": "30", "page": "1"]
        case .privateUserUnfollowAPIlink:
            return nil
        case .privateUserFollowAPILink:
            return nil
        }
    }
}

// MARK: - URLRequestConvertible
extension Router: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        let requestURL = try baseURL.asURL().appendingPathComponent(path)
        var request = URLRequest(url: requestURL)
        request.method = method
        if method == .get {
            request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        } else if method == .post {
            request = try JSONParameterEncoder().encode(parameters, into: request)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
        }
        return request
    }
}
