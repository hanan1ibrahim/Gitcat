//
//  Router.swift
//  Gitcat
//
//  Created by Hanan Ibrahim on 07/12/2021.
//


import Alamofire

enum Router {
    case usersListAPIlink
    case gitPublicRepositories
    
    var baseURL: String {
        switch self {
        case .usersListAPIlink:
            return "https://api.github.com"
        case .gitPublicRepositories:
            return "https://api.github.com"
        }
    }
    
    var path: String {
        switch self {
        case .usersListAPIlink:
            return "/users"
        case .gitPublicRepositories:
            return "/search/repositories"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .usersListAPIlink:
            return .get
        case .gitPublicRepositories:
            return .get
        }
    }
    
    var parameters: [String: String]? {
        switch self {
        case .usersListAPIlink:
            return nil
        case .gitPublicRepositories:
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
        request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        return request
    }
}
