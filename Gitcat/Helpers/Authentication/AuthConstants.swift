//
//  AuthConstants.swift
//  Gitcat
//
//  Created by Hanan Ibrahim on 07/12/2021.
//

enum Constants {
    //  gitcat app github outh app iD
  static let clientID = "59b127021e68a33027c4"
    // gitcat app authentication code
  static let clientSecret = "2cc103c8ca1206722a551f4756f64d054319b34e"
    // gitcat urlScheme
    static let redirectURI = "gitcatapp"
    // the items you will accesss
  static let scope = "repo user"
    // the login link
  static let authorizeURL = "https://github.com/login/oauth/authorize"
}
