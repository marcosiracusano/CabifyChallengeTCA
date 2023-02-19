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
        var chooseProductButton = ChooseProductButtonDomain.State()
        var checkoutList = CheckoutListDomain.State()
        var shouldGoToCheckout = false
    }
    
    enum Action: Equatable {
        case fetchProducts
        case fetchProductsResponse(TaskResult<[Product]>)
        case product(id: ProductDomain.State.ID, action: ProductDomain.Action)
        case getChooseProductButtonState
        case getTotalPrice
        case chooseProductButton(ChooseProductButtonDomain.Action)
        case goToCheckout(isPushed: Bool)
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
            
            ChooseProductButtonDomain.reducer.pullback(state: \.chooseProductButton,
                                                       action: /Action.chooseProductButton,
                                                       environment: { _ in
                                                           ChooseProductButtonDomain.Environment() }),
            
            .init { state, action, environment in
                switch action {
                case .fetchProducts:
                    state.shouldGoToCheckout = false
                    return .task {
                        await .fetchProductsResponse(
                            TaskResult(catching: {
                                try await environment.fetchProducts()
                            })
                        )
                    }
                    
                case .fetchProductsResponse(.success( let products)):
                    state.productList = IdentifiedArray(uniqueElements: products.map { ProductDomain.State(id: UUID(), product: $0) })
                    return .send(.getChooseProductButtonState)
                    
                case .fetchProductsResponse(.failure( let error)):
                    print(error)
                    return .none
                    
                case .product(id: let id, action: let action):
                    return .send(.getChooseProductButtonState)
                    
                case .getChooseProductButtonState:
                    state.chooseProductButton.shouldShowCheckoutButton = state.productList.map { $0.count }.reduce(0,+) > 0
                    return .send(.getTotalPrice)
                    
                case .getTotalPrice:
                    state.chooseProductButton.totalPrice = state.productList.map { $0.product.price * Double($0.count) }.reduce(0,+)
                    return .none
                    
                case .chooseProductButton(let action):
                    return .send(.goToCheckout(isPushed: true))
                    
                case .goToCheckout(let isPushed):
                    state.checkoutList.productGroups = IdentifiedArray(uniqueElements: state.productList.compactMap { state in
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
