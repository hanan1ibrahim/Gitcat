//
//  Repository.swift
//  Gitcat
//
//  Created by Hanan Ibrahim on 07/12/2021.
//
struct Repositories: Decodable {
    let items: [Repository]
}
struct Repository {
    let repositoryName: String
    let repositoryDescription: String?
    let repositoryLanguage: String?
    let repositoryURL:String
    
enum RepositoriesCodingKeys: String, CodingKey {
        case repositoryName = "name"
        case repositoryDescription = "description"
        case repositoryLanguage = "language"
        case repositoryURL = "html_url"
    }
}

extension Repository: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RepositoriesCodingKeys.self)
        repositoryName = try container.decode(String.self, forKey: .repositoryName)
        repositoryDescription = try? container.decode(String.self, forKey: .repositoryDescription)
        repositoryLanguage = try? container.decode(String.self, forKey: .repositoryLanguage)
        repositoryURL = try container.decode(String.self, forKey: .repositoryURL)
    }
}
