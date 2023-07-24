//
//  ProfileView.swift
//  OnlineStoreTCA_Demo
//
//  Created by 민성홍 on 2023/07/24.
//

import SwiftUI
import ComposableArchitecture

struct ProfileView: View {
    let store: Store<ProfileDomain.State, ProfileDomain.Action>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                Form {
                    Section {
                        Text(viewStore.profile.firstName.capitalized)
                        +
                        Text("\(viewStore.profile.lastName.capitalized)")
                    } header: {
                        Text("Full Name")
                    }

                    Section {
                        Text(viewStore.profile.email)
                    } header: {
                        Text("Email")
                    }
                }
                .task {
                    viewStore.send(.fetchUserProfile)
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(
            store: Store(
                initialState: ProfileDomain.State(),
                reducer: ProfileDomain.reducer,
                environment: ProfileDomain.Environment(
                    fetchUserProfile: { .sample }
                )
            )
        )
    }
}
