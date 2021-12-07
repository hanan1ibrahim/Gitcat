//
//  Router.swift
//  Gitcat
//
//  Created by Hanan Ibrahim on 07/12/2021.
//


import Alamofire

enum Router {
    case usersListAPIlink
    case repositoryAPIlink(String)
    
    var baseURL: String {
        switch self {
        case .usersListAPIlink:
            return "https://api.github.com"
        case .repositoryAPIlink:
            return "https://api.github.com"
        }
    }
    
    var path: String {
        switch self {
        case .usersListAPIlink:
            return "/users"
        case .repositoryAPIlink:
            return "/search/repositories"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .usersListAPIlink:
            return .get
        case .repositoryAPIlink:
            return .get
        }
    }
    
    var parameters: [String: String]? {
        switch self {
        case .usersListAPIlink:
            return nil
        case .repositoryAPIlink(let query):
            return ["per_page": "30", "sort": "stars", "order": "desc", "q": query]
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
