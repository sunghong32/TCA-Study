//
//  ProductCell.swift
//  OnlineStoreTCA_Demo
//
//  Created by 민성홍 on 2023/07/10.
//

import SwiftUI
import ComposableArchitecture

struct ProductCell: View {
    let store: Store<ProductDomain.State, ProductDomain.Action>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                AsyncImage(url: URL(string: viewStore.product.imageString)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300)
                } placeholder: {
                    ProgressView()
                        .frame(width: 300)
                }

                VStack(alignment: .leading) {
                    Text(viewStore.product.title)

                    HStack {
                        Text("$\(viewStore.product.price.description)")
                            .font(.custom("AmericanTypewriter", size: 25))
                            .fontWeight(.bold)

                        Spacer()

                        AddToCartButton(
                            store: self.store.scope(
                                state: \.addToCartState,  
                                action: ProductDomain.Action.addToCart
                            )
                        )
                    }
                }
                .font(.custom("AmericanTypewriter", size: 20))
            }
            .padding(20)
        }
    }
}

struct productCell_Previews: PreviewProvider {
    static var previews: some View {
        ProductCell(
            store: Store(
                initialState: ProductDomain.State(
                    id: UUID(),
                    product: Product.sample[0]
                ),
                reducer: ProductDomain.reducer,
                environment: ProductDomain.Environment()
            )
        )
        .previewLayout(.fixed(width: 300, height: 300))
    }
}
