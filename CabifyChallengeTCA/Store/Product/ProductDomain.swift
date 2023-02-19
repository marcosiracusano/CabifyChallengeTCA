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
        var plusMinusButton = PlusMinusButtonDomain.State()
        var count: Int {
            get { plusMinusButton.count }
            set { plusMinusButton.count = newValue }
        }
    }
    
    enum Action: Equatable {
        case tapButton(PlusMinusButtonDomain.Action)
    }
    
    struct Environment {}
    
    static let reducer = AnyReducer<State, Action, Environment>
        .combine(
            PlusMinusButtonDomain.reducer.pullback(state: \.plusMinusButton,
                                             action: /ProductDomain.Action.tapButton,
                                             environment: { _ in
                                                 PlusMinusButtonDomain.Environment()
                                             }),
            .init { state, action, environment in
                switch action {
                case .tapButton(.didTapPlusButton):
                    return .none
                case .tapButton(.didTapMinusButton):
                    state.plusMinusButton.count = max(0, state.plusMinusButton.count)
                    return .none
                }
            }
        )
}
