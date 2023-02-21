//
//  ProductListDomainTests.swift
//  CabifyChallengeTCATests
//
//  Created by Marco Siracusano on 20/02/2023.
//

import XCTest
import ComposableArchitecture
@testable import CabifyChallengeTCA

final class ProductListDomainTests: XCTestCase {
    
    func test_getChooseProductButtonState_shouldCallGetTotalPriceAction() {
        let store = TestStore(
            initialState: ProductListDomain.State(),
            reducer: ProductListDomain.reducer,
            environment: ProductListDomain.Environment()
        )
        
        store.send(.getChooseProductButtonState)
        store.receive(.getTotalPrice)
    }
    
    func test_chooseProductButton_shouldGoToCheckoutAction() {
        let store = TestStore(
            initialState: ProductListDomain.State(),
            reducer: ProductListDomain.reducer,
            environment: ProductListDomain.Environment()
        )
        
        store.send(.chooseProductButton(.goToCheckout))
        store.receive(.goToCheckout(isPushed: true)) {
            $0.shouldGoToCheckout = true
        }
    }
}
