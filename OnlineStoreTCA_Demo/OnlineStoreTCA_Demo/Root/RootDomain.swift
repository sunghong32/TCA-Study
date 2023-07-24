//
//  RootDomain.swift
//  OnlineStoreTCA_Demo
//
//  Created by 민성홍 on 2023/07/24.
//

import Foundation
import ComposableArchitecture

struct RootDomain {
    struct State: Equatable {
        var selectedTab = Tab.products
        var productListState = ProductListDomain.State()
        var profileState = ProfileDomain.State()
    }

    enum Tab {
        case products
        case profile
    }

    enum Action: Equatable {
        case tabSelected(Tab)
        case productList(ProductListDomain.Action)
        case profile(ProfileDomain.Action)
    }

    struct Environment {
        var fetchProducts: () async throws -> [Product]
        var sendOrder: ([CartItem]) async throws -> String
        var fetchUserProfile: () async throws -> UserProfile

        static let live = Self(
            fetchProducts: APIClient.live.fetchProducts,
            sendOrder: APIClient.live.sendOrder,
            fetchUserProfile: APIClient.live.fetchUserProfile
        )
    }

    static let reducer = AnyReducer<State, Action, Environment>
        .combine(
            ProductListDomain.reducer
                .pullback(
                    state: \.productListState,
                    action: /RootDomain.Action.productList,
                    environment: {
                        ProductListDomain.Environment(
                            fetchProducts: $0.fetchProducts,
                            sendOrder: $0.sendOrder
                        )
                    }
                ),
            ProfileDomain.reducer
                .pullback(
                    state: \.profileState,
                    action: /RootDomain.Action.profile,
                    environment: {
                        ProfileDomain.Environment(
                            fetchUserProfile: $0.fetchUserProfile
                        )
                    }
                ),
            .init { state, action, environment in
                switch action {
                    case .tabSelected(let tab):
                        state.selectedTab = tab
                        return .none
                    case .productList:
                        return .none
                    case .profile:
                        return .none
                }
            }
        )
}
