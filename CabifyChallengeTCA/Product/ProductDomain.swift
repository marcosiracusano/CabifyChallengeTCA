//
//  ProductDomain.swift
//  CabifyChallengeTCA
//
//  Created by Marco Siracusano on 18/02/2023.
//

import Foundation
import ComposableArchitecture

struct ProductDomain {
    struct State: Equatable, Identifiable {
        let id: UUID
        let product: Product
        var plusMinusState = PlusMinusButtonDomain.State()
    }
    
    enum Action: Equatable {
        case tapButton(PlusMinusButtonDomain.Action)
    }
    
    struct Environment {}
    
    static let reducer = AnyReducer<State, Action, Environment>
        .combine(
            PlusMinusButtonDomain.reducer.pullback(state: \.plusMinusState,
                                             action: /ProductDomain.Action.tapButton,
                                             environment: { _ in
                                                 PlusMinusButtonDomain.Environment()
                                             }),
            .init { state, action, environment in
                switch action {
                case .tapButton(.didTapPlusButton):
                    return .none
                case .tapButton(.didTapMinusButton):
                    state.plusMinusState.count = max(0, state.plusMinusState.count)
                    return .none
                }
            }
        )
}
