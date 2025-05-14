//
//  User.swift
//  UserListRxSwift
//
//  Created by Venkata Sudhakar Reddy on 13/05/25.
//

struct User: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    let avatar: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case email
        case avatar = "image"
    }
}

struct UsersResponse: Codable {
    let users: [User]
}
