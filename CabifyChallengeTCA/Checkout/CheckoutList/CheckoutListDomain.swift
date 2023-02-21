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
        var totalAmount = TotalAmountDomain.State()
        var shouldShowBuyDialog = false
    }
    
    enum Action: Equatable {
        case productGroup(id: ProductGroupDomain.State.ID, action: ProductGroupDomain.Action)
        case totalAmount(TotalAmountDomain.Action)
        case showAlert
        case dismissAlert
    }
    
    struct Environment {}
    
    static let reducer = AnyReducer<State, Action, Environment>
        .combine(
            ProductGroupDomain.reducer.forEach(state: \.productGroups,
                                               action: /Action.productGroup(id:action:),
                                               environment: { _ in ProductGroupDomain.Environment() }),
            
            .init { state, action, environment in
                switch action {
                case .productGroup(id: let id, action: let action):
                    switch action {
                    case .getDiscountedPrice:
                        state.totalAmount.totalSavings = state.productGroups.map { $0.savings }.reduce(0,+)
                    default: break
                    }
                    return .none
                    
                case .totalAmount(let action):
                    return .none
                    
                case .showAlert:
                    state.shouldShowBuyDialog = true
                    return .none
                    
                case .dismissAlert:
                    state.shouldShowBuyDialog = false
                    return .none
                }
            }
        )
}
