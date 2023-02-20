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
        var description = String()
        var totalPrice = 0.0
        var count: Int {
            get { plusMinusButton.count }
            set { plusMinusButton.count = newValue }
        }
    }
    
    enum Action: Equatable {
        case onAppear
        case tapButton(PlusMinusButtonDomain.Action)
        case getDescription
        case getTotalPrice
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
                case .onAppear:
                    return .send(.getDescription)
                    
                case .tapButton(.didTapPlusButton):
                    return .send(.getTotalPrice)
                    
                case .tapButton(.didTapMinusButton):
                    state.plusMinusButton.count = max(0, state.plusMinusButton.count)
                    return .send(.getTotalPrice)
                    
                case .getDescription:
                    let discount = getDiscount(id: state.product.id)
                    state.description = discount?.description ?? ""
                    return .none
                    
                case .getTotalPrice:
                    if let discount = getDiscount(id: state.product.id) {
                        state.totalPrice = discount.applyDiscount(quantity: state.count, unitPrice: state.product.price)
                    } else {
                        state.totalPrice = Double(state.count) * state.product.price
                    }
                    return .none
                }
            }
        )
    
    private static func getDiscount(id: ProductId) -> (any Discount)? {
        switch id {
        case .voucher:
            return TwoForOne()
        case .tshirt:
            return Bulk(bulkLimit: 3, discountPrice: 19)
        default:
            return nil
        }
    }
}
