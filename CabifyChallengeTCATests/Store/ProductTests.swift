//
//  ProductTests.swift
//  CabifyChallengeTCATests
//
//  Created by Marco Siracusano on 20/02/2023.
//

import XCTest
import ComposableArchitecture
@testable import CabifyChallengeTCA

final class ProductTests: XCTestCase {
    
    func test_onAppear_shouldCallGetDescriptionAction() {
        let store = TestStore(
            initialState: ProductDomain.State(
                id: UUID(),
                product: MockFactory.getProduct(.mug)!
            ),
            reducer: ProductDomain.reducer,
            environment: ProductDomain.Environment()
        )
        
        store.send(.onAppear)
        store.receive(.getDescription)
    }
    
    func test_tapButton_shouldCallGetTotalPriceAction() {
        let store = TestStore(
            initialState: ProductDomain.State(
                id: UUID(),
                product: MockFactory.getProduct(.mug)!
            ),
            reducer: ProductDomain.reducer,
            environment: ProductDomain.Environment()
        )
        
        store.send(.tapButton(.didTapMinusButton))
        store.receive(.getTotalPrice)
    }
    
    func test_tapButtonWithDiscountedProduct_shouldSetTheCorrespondingTotalPrice() {
        let product = MockFactory.getProduct(.tshirt)!
        let discount = DiscountHelper.getDiscount(id: product.id)!
        let quantity = 5
        let store = TestStore(
            initialState: ProductDomain.State(
                id: UUID(),
                product: product
            ),
            reducer: ProductDomain.reducer,
            environment: ProductDomain.Environment()
        )
        
        for i in 1...quantity {
            store.send(.tapButton(.didTapPlusButton)) {
                $0.plusMinusButton.count = i
            }
            store.receive(.getTotalPrice) {
                $0.totalPrice = discount.applyDiscount(quantity: i, unitPrice: product.price)
            }
        }
    }
    
    func test_tapButtonWithRegularProduct_shouldSetTheCorrespondingTotalPrice() {
        let product = MockFactory.getProduct(.mug)!
        let quantity = 5
        let store = TestStore(
            initialState: ProductDomain.State(
                id: UUID(),
                product: product
            ),
            reducer: ProductDomain.reducer,
            environment: ProductDomain.Environment()
        )
        
        for i in 1...quantity {
            store.send(.tapButton(.didTapPlusButton)) {
                $0.plusMinusButton.count = i
            }
            store.receive(.getTotalPrice) {
                $0.totalPrice = Double(i) * product.price
            }
        }
    }
    
    func test_getDescription_shouldSetTheDescriptionBasedOnProduct() {
        let product = MockFactory.getProduct(.tshirt)!
        let store = TestStore(
            initialState: ProductDomain.State(
                id: UUID(),
                product: product
            ),
            reducer: ProductDomain.reducer,
            environment: ProductDomain.Environment()
        )
        
        store.send(.getDescription) {
            $0.description = DiscountHelper.getDiscount(id: product.id)?.description ?? ""
        }
    }
}
