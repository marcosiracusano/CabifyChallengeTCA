//
//  CheckoutButtonDomain.swift
//  CabifyChallengeTCA
//
//  Created by Marco Siracusano on 19/02/2023.
//

import Foundation
import ComposableArchitecture

struct CheckoutButtonDomain {
    
    struct State: Equatable {
        var shouldShowCheckoutButton = false
        var totalPrice = 0.0
    }
    
    enum Action: Equatable {
        case goToCheckout
    }
    
    struct Environment {}
    
    static let reducer = AnyReducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .goToCheckout:
            return .none
        }
    }
}
