//
//  ProductGroupTests.swift
//  CabifyChallengeTCATests
//
//  Created by Marco Siracusano on 20/02/2023.
//

import XCTest
import ComposableArchitecture
@testable import CabifyChallengeTCA

final class ProductGroupTests: XCTestCase {

    func test_onAppearWithDiscountedProductGroup_shouldSetTheCorrespondingDiscountedPrice() {
        let productGroup = MockFactory.voucherProductGroupExample
        let discount = DiscountHelper.getDiscount(id: productGroup.product.id)!
        let store = TestStore(
            initialState: ProductGroupDomain.State(
                id: UUID(),
                productGroup: productGroup
            ),
            reducer: ProductGroupDomain.reducer,
            environment: ProductGroupDomain.Environment()
        )
        
        store.send(.onAppear)
        store.receive(.getFullPrice) {
            $0.fullPrice = Double($0.productGroup.quantity) * $0.productGroup.product.price
        }
        store.receive(.getDiscountedPrice) {
            $0.discountedPrice = discount.applyDiscount(quantity: productGroup.quantity, unitPrice: productGroup.product.price)
            $0.shouldShowStrikethroughPrice = true
        }
    }
    
    func test_onAppearWithRegularProductGroup_shouldSetTheCorrespondingFullPrice() {
        let productGroup = MockFactory.mugProductGroupExample
        let store = TestStore(
            initialState: ProductGroupDomain.State(
                id: UUID(),
                productGroup: productGroup
            ),
            reducer: ProductGroupDomain.reducer,
            environment: ProductGroupDomain.Environment()
        )
        
        store.send(.onAppear)
        store.receive(.getFullPrice) {
            $0.fullPrice = Double($0.productGroup.quantity) * $0.productGroup.product.price
        }
        store.receive(.getDiscountedPrice) {
            $0.discountedPrice = $0.fullPrice
            $0.shouldShowStrikethroughPrice = false
        }
    }
}
