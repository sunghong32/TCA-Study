//
//  OnlineStoreTCA_DemoApp.swift
//  OnlineStoreTCA_Demo
//
//  Created by 민성홍 on 2023/07/07.
//

import SwiftUI
import ComposableArchitecture

@main
struct OnlineStoreTCA_DemoApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(
                store: Store(
                    initialState: RootDomain.State(),
                    reducer: RootDomain.reducer,
                    environment: .live
                )
            )
        }
    }
}
