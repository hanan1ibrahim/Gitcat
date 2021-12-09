//
//  TokenManger.swift
//  Gitcat
//
//  Created by Hanan Ibrahim on 07/12/2021.
//
import Alamofire

class TokenManager {
    let userAccount = "accessToken"
    static let shared = TokenManager()
    let afSession: Session = {
        let interceptor = RequestIntercptor()
        return Session(
            interceptor: interceptor)
    }()
    func fetchAccessToken(accessToken: String, completion: @escaping (Bool) -> Void) {
        afSession.request(Router.accessTokenAPIlink(accessToken))
            .responseDecodable(of: AccessToken.self) { response in
                guard let token = response.value else { return completion(false) }
                TokenManager.shared.saveAccessToken(gitToken: token)
                completion(true)
            }
    }
    let secureStore: SecureStore = {
        let accessTokenQueryable = GenericPasswordQueryable(service: "GitHubService")
        return SecureStore(secureStoreQueryable: accessTokenQueryable)
    }()
    func saveAccessToken(gitToken: AccessToken) {
        do {
            try secureStore.setValue(gitToken.accessToken, for: userAccount)
        } catch let exception {
            print("Error saving access token: \(exception)")
        }
    }
    func fetchAccessToken() -> String? {
        do {
            return try secureStore.getValue(for: userAccount)
        } catch let exception {
            print("Error fetching access token: \(exception)")
        }
        return nil
    }
    func clearAccessToken() {
        do {
            return try secureStore.removeValue(for: userAccount)
        } catch let exception {
            print("Error clearing access token: \(exception)")
        }
    }
}
