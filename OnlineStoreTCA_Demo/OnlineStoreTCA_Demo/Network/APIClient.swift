//
//  APIClient.swift
//  OnlineStoreTCA_Demo
//
//  Created by 민성홍 on 2023/07/19.
//

import Foundation

struct APIClient {
    var fetchProducts: () async throws -> [Product]
    var sendOrder: ([CartItem]) async throws -> String
    var fetchUserProfile: () async throws -> UserProfile

    struct Failure: Error {}
}

extension APIClient {
    static let live = Self(
        fetchProducts: {
            let (data, _) = try await URLSession.shared
                .data(from: URL(string: "https://fakestoreapi.com/products")!)
            let products = try JSONDecoder().decode([Product].self, from: data)
            return products
        },
        sendOrder: { cartItems in
            let payload = try JSONEncoder().encode(cartItems)
            var urlRequest = URLRequest(url: URL(string: "https://fakestoreapi.com/carts")!)
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpMethod = "POST"

            let (data, response) = try await URLSession.shared.upload(for: urlRequest, from: payload)

            guard let httpResponse = (response as? HTTPURLResponse) else {
                throw Failure()
            }

            return "Status: \(httpResponse.statusCode)"
        }, fetchUserProfile: {
            let (data, _) = try await URLSession.shared
                .data(from: URL(string: "https://fakestoreapi.com/users/1")!)
            let profile = try JSONDecoder().decode(UserProfile.self, from: data)
            return profile
        }
    )
}
