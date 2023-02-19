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
        var checkoutButtonState = CheckoutButtonDomain.State()
        var shouldGoToCheckout = false
    }
    
    enum Action: Equatable {
        case fetchProducts
        case fetchProductsResponse(TaskResult<[Product]>)
        case product(id: ProductDomain.State.ID, action: ProductDomain.Action)
        case getCheckoutButtonState
        case getTotalPrice
        case checkoutButton(CheckoutButtonDomain.Action)
        case goToCheckout
    }
    
    struct Environment {
        func fetchProducts() async throws -> [Product] {
            let url = URL(string: "https://gist.githubusercontent.com/palcalde/6c19259bd32dd6aafa327fa557859c2f/raw/ba51779474a150ee4367cda4f4ffacdcca479887/Products.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let productsData = try JSONDecoder().decode([String:[Product]].self, from: data)
            return productsData["products"] ?? []
        }
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
                    return .send(.getCheckoutButtonState)
                    
                case .getCheckoutButtonState:
                    state.checkoutButtonState.shouldShowCheckoutButton = state.productList.map { $0.count }.reduce(0,+) > 0
                    return .send(.getTotalPrice)
                    
                case .getTotalPrice:
                    state.checkoutButtonState.totalPrice = state.productList.map { $0.product.price * Double($0.count) }.reduce(0,+)
                    return .none
                    
                case .checkoutButton(let action):
                    return .send(.goToCheckout)
                    
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
        ).debug()
}
