//
//  ErrorView.swift
//  OnlineStoreTCA_Demo
//
//  Created by 민성홍 on 2023/07/24.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let retryAction: () -> Void

    var body: some View {
        VStack {
            Text(":(")
                .font(.custom("AmericanTypewriter", size: 50))
            Text("")
            Text(message)
                .font(.custom("AmericanTypewriter", size: 25))
            Button {
                retryAction()
            } label: {
                Text("Retry")
                    .font(.custom("AmericanTypewriter", size: 25))
                    .foregroundColor(.white)
            }
            .frame(width: 100, height: 60)
            .background(.blue)
            .cornerRadius(10)
            .padding(10)
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(message: "Oops, we couldn't fetch product list", retryAction: {})
    }
}
