//
//  Token.swift
//  Gitcat
//
//  Created by Hanan Ibrahim on 07/12/2021.
//

import Foundation

struct AccessToken: Decodable {
  let accessToken: String
  let tokenType: String

  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case tokenType = "token_type"
  }
}
