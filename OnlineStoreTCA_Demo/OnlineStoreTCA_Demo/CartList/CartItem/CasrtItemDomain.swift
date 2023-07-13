//
//  CasrtItemDomain.swift
//  OnlineStoreTCA_Demo
//
//  Created by 민성홍 on 2023/07/11.
//

import Foundation
import ComposableArchitecture

struct CartItemDomain {
    struct State: Equatable, Identifiable {
        let id: UUID
        let cartItem: CartItem
    }

    enum Action: Equatable {
        case deleteCartItem(product: Product)
    }

    struct Environment {}

    static let reducer = AnyReducer<State, Action, Environment> { state, action, environment in
        switch action {
            case .deleteCartItem:
                return .none
        }
    }
}
