//
//  AddToCartDomain.swift
//  CabifyChallengeTCA
//
//  Created by Marco Siracusano on 17/02/2023.
//

import Foundation
import ComposableArchitecture

struct PlusMinusButtonDomain {
    struct State: Equatable {
        var count = 0
    }
    
    enum Action: Equatable {
        case didTapPlusButton
        case didTapMinusButton
    }
    
    struct Environment {}
    
    static let reducer = AnyReducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .didTapPlusButton:
            state.count += 1
            return .none
        case .didTapMinusButton:
            state.count -= 1
            return .none
        }
    }
}
