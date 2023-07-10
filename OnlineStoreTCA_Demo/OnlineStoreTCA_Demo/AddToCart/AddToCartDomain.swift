//
//  AddToCartDomain.swift
//  OnlineStoreTCA_Demo
//
//  Created by 민성홍 on 2023/07/10.
//

import Foundation
import ComposableArchitecture

struct AddToCartDomain {
    struct State: Equatable {
        var count: Int = 0
    }

    enum Action: Equatable {
        case didTapPlusButton
        case didTapMinusButton
    }

    struct Environment {
        // Future Dependencies...
    }

    static let reducer = AnyReducer<State, Action, Environment> { state, action, environment in
        switch action {
            case .didTapPlusButton:
                state.count += 1
                return EffectTask.none
            case .didTapMinusButton:
                state.count -= 1
                return EffectTask.none
        }
    }
}
