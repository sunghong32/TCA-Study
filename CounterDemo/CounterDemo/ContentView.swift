//
//  ContentView.swift
//  CounterDemo
//
//  Created by 민성홍 on 2023/07/07.
//

import SwiftUI
import ComposableArchitecture

struct State: Equatable {
    var counter: Int = 0
}

enum Action: Equatable {
    case increaseCounter
    case decreaseCounter
}

struct Environment {
    // Future Dependencies...
}

let reducer = AnyReducer<State, Action, Environment> { state, action, environment in
    switch action {
        case .increaseCounter:
            state.counter += 1
            return EffectTask.none
        case .decreaseCounter:
            state.counter -= 1
            return EffectTask.none
    }
}

struct ContentView: View {
    let store: Store<State, Action>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack {
                Button {
                    viewStore.send(.decreaseCounter)
                } label: {
                    Text("-")
                        .padding(10)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .buttonStyle(.plain)

                Text(viewStore.counter.description)
                    .padding(5)

                Button {
                    viewStore.send(.increaseCounter)
                } label: {
                    Text("+")
                        .padding(10)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            store: Store(
                initialState: State(),
                reducer: reducer,
                environment: Environment()
            )
        )
    }
}
