//
//  AddToCartButton.swift
//  OnlineStoreTCA_Demo
//
//  Created by 민성홍 on 2023/07/10.
//

import SwiftUI
import ComposableArchitecture

struct AddToCartButton: View {
    let store: Store<AddToCartDomain.State, AddToCartDomain.Action>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            if viewStore.count > 0 {
                PlustMinusButton(store: self.store)
            } else {
                Button {
                    viewStore.send(.didTapPlusButton)
                } label: {
                    Text("Add to Cart")
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

struct AddToCartButton_Previews: PreviewProvider {
    static var previews: some View {
        AddToCartButton(
            store: Store(
                initialState: AddToCartDomain.State(),
                reducer: AddToCartDomain.reducer,
                environment: AddToCartDomain.Environment()
            )
        )
    }
}
