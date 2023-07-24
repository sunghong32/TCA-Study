//
//  UserProfile.swift
//  OnlineStoreTCA_Demo
//
//  Created by 민성홍 on 2023/07/24.
//

import Foundation

struct UserProfile: Equatable {
    let id: Int
    let email: String
    let firstName: String
    let lastName: String
}

extension UserProfile: Decodable {
    private enum ProfileKeys: String, CodingKey {
        case id
        case email
        case name
        case firstname
        case lastname
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ProfileKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.email = try container.decode(String.self, forKey: .email)

        let nameContainer = try container.nestedContainer(keyedBy: ProfileKeys.self, forKey: .name)
        self.firstName = try nameContainer.decode(String.self, forKey: .firstname)
        self.lastName = try nameContainer.decode(String.self, forKey: .lastname)
    }
}

extension UserProfile {
    static var sample: UserProfile {
        .init(
            id: 1,
            email: "hello@demo.com",
            firstName: "Sunghong",
            lastName: "Min"
        )
    }

    static var `default`: UserProfile {
        .init(
            id: 0,
            email: "",
            firstName: "",
            lastName: ""
        )
    }
}
