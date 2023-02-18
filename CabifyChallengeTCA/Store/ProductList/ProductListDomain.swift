//
//  ProductListDomain.swift
//  CabifyChallengeTCA
//
//  Created by Marco Siracusano on 18/02/2023.
//

import Foundation
import ComposableArchitecture

struct ProductListDomain {
    struct State: Equatable {
        var productList: IdentifiedArrayOf<ProductDomain.State> = []
        var checkoutCartState = CheckoutListDomain.State()
        var shouldGoToCheckout = false
        var shouldShowCheckoutButton: Bool {
            productList.map { $0.count }.reduce(0,+) > 0
        }
    }
    
    enum Action: Equatable {
        case fetchProducts
        case fetchProductsResponse(TaskResult<[Product]>)
        case product(id: ProductDomain.State.ID, action: ProductDomain.Action)
        case goToCheckout
    }
    
    struct Environment {
        var fetchProducts: () async throws -> [Product]
    }
    
    static let reducer = AnyReducer<State, Action, Environment>
        .combine(
            ProductDomain.reducer.forEach(state: \.productList,
                                          action: /Action.product(id:action:),
                                          environment: { _ in ProductDomain.Environment() }),
            
            .init { state, action, environment in
                switch action {
                case .fetchProducts:
                    return .task {
                        await .fetchProductsResponse(
                            TaskResult(catching: {
                                try await environment.fetchProducts()
                            })
                        )
                    }
                    
                case .fetchProductsResponse(.success( let products)):
                    state.productList = IdentifiedArray(uniqueElements: products.map { ProductDomain.State(id: UUID(), product: $0) })
                    return .none
                    
                case .fetchProductsResponse(.failure( let error)):
                    print(error)
                    return .none
                    
                case .product(id: let id, action: let action):
                    return .none
                    
                case .goToCheckout:
                    state.checkoutCartState.productGroups = IdentifiedArray(uniqueElements: state.productList.compactMap { state in
                        state.count > 0 ?
                        ProductGroupDomain.State(id: UUID(),
                                                 productGroup: ProductGroup(product: state.product,
                                                                            quantity: state.count))
                        : nil
                    })
                    state.shouldGoToCheckout = true
                    return .none
                }
            }
        )
}
