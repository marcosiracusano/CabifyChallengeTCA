//
//  ProductGroupDomain.swift
//  CabifyChallengeTCA
//
//  Created by Marco Siracusano on 18/02/2023.
//

import Foundation
import ComposableArchitecture

struct ProductGroupDomain {
    
    struct State: Equatable, Identifiable {
        var id: UUID
        var productGroup: ProductGroup
        var fullPrice = 0.0
        var discountedPrice = 0.0
        var savings: Double {
            fullPrice - discountedPrice
        }
        var shouldShowStrikethroughPrice = false
    }
    
    enum Action: Equatable {
        case onAppear
        case getFullPrice
        case getDiscountedPrice
    }
    
    struct Environment {}
    
    static let reducer = AnyReducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .onAppear:
            return .send(.getFullPrice)
            
        case .getFullPrice:
            state.fullPrice = Double(state.productGroup.quantity) * state.productGroup.product.price
            return .send(.getDiscountedPrice)
            
        case .getDiscountedPrice:
            if let discount = DiscountHelper.getDiscount(id: state.productGroup.product.id) {
                state.discountedPrice = discount.applyDiscount(quantity: state.productGroup.quantity, unitPrice: state.productGroup.product.price)
                state.shouldShowStrikethroughPrice = true
            } else {
                state.discountedPrice = state.fullPrice
            }
            return .none
        }
    }
}
