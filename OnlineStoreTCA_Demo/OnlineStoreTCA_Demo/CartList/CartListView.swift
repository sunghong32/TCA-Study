//
//  CartListView.swift
//  OnlineStoreTCA_Demo
//
//  Created by 민성홍 on 2023/07/11.
//

import SwiftUI
import ComposableArchitecture

struct CartListView: View {
    let store: Store<CartListDomain.State, CartListDomain.Action>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationStack {
                List {
                    ForEachStore(
                        self.store.scope(
                            state: \.cartItems,
                            action: CartListDomain.Action.cartItem(id:action:))
                    ) {
                        CartCell(store: $0)
                    }
                }
                .navigationTitle("Cart")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            viewStore.send(.didPressCloseButton)
                        } label: {
                            Text("Close")
                        }
                    }
                }
                .onAppear {
                    viewStore.send(.getTotalPrice)
                }
                .safeAreaInset(edge: .bottom) {
                    Button {
                        viewStore.send(.didPressPayButton)
                    } label: {
                        HStack(alignment: .center) {
                            Spacer()

                            Text("Pay \(viewStore.totalPriceString)")
                                .font(.custom("AmericanTypewriter", size: 30))
                                .foregroundColor(.white)

                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .background(
                        viewStore.isPayButtonDisable
                        ? .gray
                        : .blue                        
                    )
                    .cornerRadius(10)
                    .padding()
                    .disabled(viewStore.isPayButtonDisable)
                }
            }
            .alert(
                self.store.scope(state: \.confirmationAlert),
                dismiss: .didCancelConfirmation
            )
            .alert(
                self.store.scope(state: \.successAlert),
                dismiss: .dismissSuccessAlert
            )
            .alert(
                self.store.scope(state: \.errorAlert),
                dismiss: .dismissSuccessAlert
            )
        }
    }
}

struct CartListView_Previews: PreviewProvider {
    static var previews: some View {
        CartListView(
            store: Store(
                initialState: CartListDomain.State(
                    cartItems: IdentifiedArrayOf(
                        uniqueElements: CartItem.sample
                            .map {
                                CartItemDomain.State(
                                    id: UUID(),
                                    cartItem: $0)
                            }
                    )
                ),
                reducer: CartListDomain.reducer,
                environment: CartListDomain.Environment(sendOrder: { _ in "OK" })
            )
        )
    }
}
