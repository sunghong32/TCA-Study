//
//  CartListDomain.swift
//  OnlineStoreTCA_Demo
//
//  Created by 민성홍 on 2023/07/11.
//

import Foundation
import ComposableArchitecture

struct CartListDomain {
    struct State: Equatable {
        var cartItems: IdentifiedArrayOf<CartItemDomain.State> = []
        var totalPrice: Double = 0.0
        var isPayButtonDisable: Bool = false

        var totalPriceString: String {
            let roundedValue = round(totalPrice * 100) / 100.0
            return "$\(roundedValue)"
        }
    }

    enum Action: Equatable {
        case didPressCloseButton
        case cartItem(id: CartItemDomain.State.ID, action: CartItemDomain.Action)
        case getTotalPrice
        case didPressPayButton
        case didReceivePurchaseResponse(TaskResult<String>)
    }

    struct Environment {
        var sendOrder: ([CartItem]) async throws -> String
    }

    static let reducer = AnyReducer<State, Action, Environment>
        .combine(
            CartItemDomain.reducer.forEach(
                state: \.cartItems, action: /Action.cartItem(id: action:),
                environment: { _ in CartItemDomain.Environment() }
            ),
            .init { state, action, environment in
                switch action {
                    case .didPressCloseButton:
                        return .none
                    case .cartItem(let id, let action):
                        switch action {
                            case .deleteCartItem:
                                state.cartItems.remove(id: id)
                                return EffectTask(value: .getTotalPrice)
                        }
                    case .getTotalPrice:
                        let items = state.cartItems.map { $0.cartItem }
                        state.totalPrice = items.reduce(0.0, {
                            $0 + ($1.product.price * Double($1.quantity))
                        })
                        return verifyPayButtonVisibility(state: &state)
                    case .didPressPayButton:
                        let items = state.cartItems.map { $0.cartItem }
                        return .task {
                            await .didReceivePurchaseResponse(
                                TaskResult {
                                    try await environment.sendOrder(items)
                                }
                            )
                        }
                    case .didReceivePurchaseResponse(.success(let message)):
                        print(message)
                        return .none

                    case .didReceivePurchaseResponse(.failure(let error)):
                        print(error.localizedDescription)
                        return .none
                }
            }
        )

    private static func verifyPayButtonVisibility(state: inout State) -> EffectTask<Action> {
        state.isPayButtonDisable = state.totalPrice == 0.0
        return .none
    }
}
