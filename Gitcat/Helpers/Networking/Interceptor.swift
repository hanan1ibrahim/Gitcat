//
//  Interceptor.swift
//  Gitcat
//
//  Created by Hanan Ibrahim on 07/12/2021.
//

import Alamofire

class RequestIntercptor: RequestInterceptor {
  func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
    var urlRequest = urlRequest
    if let token = TokenManager.shared.fetchAccessToken() {
      urlRequest.setValue("token \(token)", forHTTPHeaderField: "Authorization")
    }
    completion(.success(urlRequest))
  }
}
