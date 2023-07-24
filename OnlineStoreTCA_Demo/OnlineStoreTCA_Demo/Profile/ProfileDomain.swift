//
//  ProfileDomain.swift
//  OnlineStoreTCA_Demo
//
//  Created by 민성홍 on 2023/07/24.
//

import Foundation
import ComposableArchitecture

struct ProfileDomain {
    struct State: Equatable {
        var profile: UserProfile = .default
    }

    enum Action: Equatable {
        case fetchUserProfile
        case fetchUserProfileResponse(TaskResult<UserProfile>)
    }

    struct Environment {
        var fetchUserProfile: () async throws -> UserProfile
    }

    static let reducer = AnyReducer<State, Action, Environment> { state, action, environment in
        switch action {
            case .fetchUserProfile:
                return .task {
                    await .fetchUserProfileResponse(
                        TaskResult {
                            try await environment.fetchUserProfile()
                        }
                    )
                }
            case .fetchUserProfileResponse(.success(let profile)):
                state.profile = profile
                return .none
            case .fetchUserProfileResponse(.failure(let error)):
                print("Error: \(error)")
                return .none
        }

    }
}
