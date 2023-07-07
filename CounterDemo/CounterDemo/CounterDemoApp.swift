//
//  CounterDemoApp.swift
//  CounterDemo
//
//  Created by 민성홍 on 2023/07/07.
//

import SwiftUI
import ComposableArchitecture

@main
struct CounterDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(
                    initialState: State(),
                    reducer: reducer,
                    environment: Environment()
                )
            )
        }
    }
}
