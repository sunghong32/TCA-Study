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
            ProductListView(
                store: Store(
                    initialState: ProductListDomain.State(),
                    reducer: ProductListDomain.reducer,
                    environment: ProductListDomain.Environment(
                        fetchProducts: APIClient.live.fetchProducts,
                        sendOrder: APIClient.live.sendOrder
                    )
                )
            )
        }
    }
}
