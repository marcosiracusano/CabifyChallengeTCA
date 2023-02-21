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
        var viewDidLoad = false
        var alert: AlertState<Action>?
    }
    
    enum Action: Equatable {
        case onAppear
        case fetchProducts
        case fetchProductsResponse(TaskResult<[Product]>)
        case alertCancelTapped
        case alertRetryTapped
        case product(id: ProductDomain.State.ID, action: ProductDomain.Action)
        case getChooseProductButtonState
        case getTotalPrice
        case chooseProductButton(ChooseProductButtonDomain.Action)
        case goToCheckout(isPushed: Bool)
    }
    
    struct Environment {
        enum FetchProductsError: Error {
            case invalidStatusCode
            case failedToDecode
        }
        
        func fetchProducts() async throws -> [Product] {
            let url = URL(string: "https://gist.githubusercontent.com/palcalde/6c19259bd32dd6aafa327fa557859c2f/raw/ba51779474a150ee4367cda4f4ffacdcca479887/Products.json")!
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw FetchProductsError.invalidStatusCode
            }
            
            do {
                let productsData = try JSONDecoder().decode([String:[Product]].self, from: data)
                return productsData["products"] ?? []
            } catch {
                throw FetchProductsError.failedToDecode
            }
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
                case .onAppear:
                    state.shouldGoToCheckout = false
                    
                    if state.viewDidLoad {
                        return .none
                    } else {
                        state.viewDidLoad = true
                        return .send(.fetchProducts)
                    }
                    
                case .fetchProducts:
                    return .task {
                        await .fetchProductsResponse(
                            TaskResult(catching: {
                                try await environment.fetchProducts()
                            })
                        )
                    }
                    
                case .fetchProductsResponse(.success( let products)):
                    state.alert = nil
                    state.productList = IdentifiedArray(uniqueElements: products.map { ProductDomain.State(id: UUID(), product: $0) })
                    return .send(.getChooseProductButtonState)
                    
                case .fetchProductsResponse(.failure( let error)):
                    state.alert = AlertState {
                        TextState("Error")
                    } actions: {
                        ButtonState(role: .cancel, action: .send(.alertCancelTapped)) {
                            TextState("Cancel")
                        }
                        ButtonState(action: .send(.alertRetryTapped)) {
                            TextState("Retry")
                        }
                    } message: {
                        TextState(error.localizedDescription)
                    }
                    return .none
                    
                case .alertCancelTapped:
                    state.alert = nil
                    return .none
                    
                case .alertRetryTapped:
                    state.alert = nil
                    return .send(.fetchProducts)
                    
                case .product(id: let id, action: let action):
                    return .send(.getChooseProductButtonState)
                    
                case .getChooseProductButtonState:
                    state.chooseProductButton.shouldShowCheckoutButton = state.productList.map { $0.count }.reduce(0,+) > 0
                    return .send(.getTotalPrice)
                    
                case .getTotalPrice:
                    let totalPrice = state.productList.map { $0.totalPrice }.reduce(0,+)
                    state.chooseProductButton.totalPrice = totalPrice
                    state.checkoutList.totalAmount.totalPrice = totalPrice
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
        )
}
