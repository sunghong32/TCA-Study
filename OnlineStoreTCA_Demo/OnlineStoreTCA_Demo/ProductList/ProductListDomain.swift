//
//  ProductListDomain.swift
//  OnlineStoreTCA_Demo
//
//  Created by 민성홍 on 2023/07/10.
//

import Foundation
import ComposableArchitecture

struct ProductListDomain {
    struct State: Equatable {
        var productList: IdentifiedArrayOf<ProductDomain.State> = []
        var cartState: CartListDomain.State?
        var shouldOpenCart: Bool = false
    }

    enum Action: Equatable {
        case fetchProducts
        case fetchProductResponse(TaskResult<[Product]>)
        case product(id: ProductDomain.State.ID, action: ProductDomain.Action)
        case setCartView(isPresented: Bool)
        case cart(CartListDomain.Action)
    }

    struct Environment {
        var fetchProducts: () async throws -> [Product]
        var sendOrder: ([CartItem]) async throws -> String
    }

    static let reducer = AnyReducer<
        State, Action, Environment
    >.combine(
        ProductDomain.reducer.forEach(
            state: \.productList,
            action: /Action.product(id:action:),
            environment: { _ in ProductDomain.Environment() }
        ),
        CartListDomain.reducer
            .optional()
            .pullback(
                state: \.cartState,
                action: /ProductListDomain.Action.cart,
                environment: {
                    CartListDomain.Environment(
                        sendOrder: $0.sendOrder
                    )
                }
            ),
        .init { state, action, environment in
            switch action {
                case .fetchProducts:
                    return .task {
                        await .fetchProductResponse(
                            TaskResult {
                                try await environment.fetchProducts()
                            }
                        )
                    }
                case .fetchProductResponse(.success(let products)):
                    state.productList = IdentifiedArray(
                        uniqueElements: products
                            .map {
                                ProductDomain.State(id: UUID(), product: $0)
                            }
                    )
                    return .none
                case .fetchProductResponse(.failure(let error)):
                    print(error)
                    print("Unable to fetch products")
                    return .none
                case .product:
                    return .none
                case .cart(let action):
                    switch action {
                        case .didPressCloseButton:
                            state.shouldOpenCart = false
                        case .cartItem(_, action: let action):
                            switch action {
                                case .deleteCartItem(let product):
                                    guard let index = state.productList.firstIndex(
                                        where: { $0.product.id == product.id }
                                    ) else { return .none }

                                    let productStateId = state.productList[index].id
                                    state.productList[id: productStateId]?.count = 0
                            }
                            return .none
                        case .dismissSuccessAlert:
                            resetProductToZero(state: &state)
                            state.shouldOpenCart = false
                            return .none
                        default:
                            break
                    }
                    return .none
                case .setCartView(isPresented: let isPresented):
                    state.shouldOpenCart = isPresented
                    state.cartState = isPresented
                    ? CartListDomain.State(
                        cartItems: IdentifiedArray(
                            uniqueElements: state
                                .productList
                                .compactMap { state in
                                    state.count > 0
                                    ? CartItemDomain.State(
                                        id: UUID(),
                                        cartItem: CartItem(
                                            product: state.product,
                                            quantity: state.count
                                        )
                                    )
                                    : nil
                                }
                        )
                    )
                    : nil
                    return .none
            }
        }
    )
    .debug()

    private static func resetProductToZero(
        state: inout State
    ) {
        for id in state.productList.map(\.id) {
            state.productList[id: id]?.count = 0
        }
    }
}
