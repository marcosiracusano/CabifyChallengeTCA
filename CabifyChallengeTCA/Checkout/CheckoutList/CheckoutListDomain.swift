//
//  CheckoutDomain.swift
//  CabifyChallengeTCA
//
//  Created by Marco Siracusano on 18/02/2023.
//

import Foundation
import ComposableArchitecture

struct CheckoutListDomain {
    
    struct State: Equatable {
        var productGroups: IdentifiedArrayOf<ProductGroupDomain.State> = []
        var shouldShowBuyDialog = false
    }
    
    enum Action: Equatable {
        case productGroup(id: ProductGroupDomain.State.ID, action: ProductGroupDomain.Action)
        case showBuyDialog
    }
    
    struct Environment {}
    
    static let reducer = AnyReducer<State, Action, Environment>
        .combine(
            .init { state, action, environment in
                switch action {
                case .productGroup(id: let id, action: let action):
                    return .none
                    
                case .showBuyDialog:
                    state.shouldShowBuyDialog = true
                    return .none
                }
            }
        )
}
