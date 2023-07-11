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
//            PlustMinusButton(
//                store: Store(
//                    initialState: AddToCartDomain.State(),
//                    reducer: AddToCartDomain.reducer,
//                    environment: AddToCartDomain.Environment()
//                )
//            )

            ProductListView(
                store: Store(
                    initialState: ProductListDomain.State(),
                    reducer: ProductListDomain.reducer,
                    environment: ProductListDomain.Environment(
                        fetchProducts: {
                            Product.sample
                        }
                    )
                )
            )
        }
    }
}
