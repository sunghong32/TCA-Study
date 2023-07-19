//
//  CartItem.swift
//  OnlineStoreTCA_Demo
//
//  Created by 민성홍 on 2023/07/11.
//

import Foundation

struct CartItem: Equatable {
    let product: Product
    let quantity: Int
}

extension CartItem: Encodable {
    private enum CartItemsKey: String, CodingKey {
        case productId
        case quantity
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CartItemsKey.self)
        try container.encode(product.id, forKey: .productId)
        try container.encode(quantity, forKey: .quantity)
    }
}

extension CartItem {
    static var sample: [CartItem] {
        [
            .init(
                product: Product.sample[0],
                quantity: 3
            ),
            .init(
                product: Product.sample[1],
                quantity: 1
            ),
            .init(
                product: Product.sample[2],
                quantity: 1
            )
        ]
    }
}
