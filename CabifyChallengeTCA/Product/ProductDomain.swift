//
//  ProductDomain.swift
//  CabifyChallengeTCA
//
//  Created by Marco Siracusano on 18/02/2023.
//

import Foundation
import ComposableArchitecture

struct ProductDomain {
    struct State: Equatable {
        let product: Product
        var plusMinusState = PlusMinusDomain.State()
    }
    
    enum Action: Equatable {
        case addToCart(PlusMinusDomain.Action)
    }
    
    struct Environment {}
    
    static let reducer = AnyReducer<State, Action, Environment>
        .combine(
            PlusMinusDomain.reducer.pullback(state: \.plusMinusState,
                                             action: /ProductDomain.Action.addToCart,
                                             environment: { _ in
                                                 PlusMinusDomain.Environment()
                                             }),
            .init { state, action, environment in
                switch action {
                case .addToCart(.didTapPlusButton):
                    return .none
                case .addToCart(.didTapMinusButton):
                    state.plusMinusState.count = max(0, state.plusMinusState.count)
                    return .none
                }
            }
        )
}
