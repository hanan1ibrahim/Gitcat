//
//  Orgs.swift
//  Gitcat
//
//  Created by HANAN on 14/05/1443 AH.
//

import Foundation
struct Orgs {
    let orgName: String
    let orgDescription: String?

    enum Orgs: String, CodingKey {
        case orgName = "login"
        case orgDescription = "description"
    }
}

extension Orgs: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Orgs.self)
        orgName = try container.decode(String.self, forKey: .orgName)
        orgDescription = try container.decode(String.self, forKey: .orgDescription)
    }
}
