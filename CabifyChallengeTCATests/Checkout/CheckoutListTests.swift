//
//  CheckoutListTests.swift
//  CabifyChallengeTCATests
//
//  Created by Marco Siracusano on 20/02/2023.
//

import XCTest
import ComposableArchitecture
@testable import CabifyChallengeTCA

final class CheckoutListTests: XCTestCase {
    
    func test_productGroup_shouldSetTotalSavingsIntoTotalAmount() {
        let productGroup = MockFactory.voucherProductGroupExample
        let discount = DiscountHelper.getDiscount(id: productGroup.product.id)!
        let id = UUID()
        let store = TestStore(
            initialState: CheckoutListDomain.State(
                productGroups: IdentifiedArray(
                    uniqueElements: [ProductGroupDomain.State(id: id, productGroup: productGroup)]
                )
            ),
            reducer: CheckoutListDomain.reducer,
            environment: CheckoutListDomain.Environment()
        )
        
        store.send(.productGroup(id: id, action: .onAppear))
        
        store.receive(.productGroup(id: id, action: .getFullPrice)) {
            $0.productGroups[0].fullPrice = Double($0.productGroups[0].productGroup.quantity) * $0.productGroups[0].productGroup.product.price
        }
        
        store.receive(.productGroup(id: id, action: .getDiscountedPrice)) {
            $0.productGroups[0].shouldShowStrikethroughPrice = true
            $0.productGroups[0].discountedPrice = discount.applyDiscount(quantity: productGroup.quantity,
                                                                         unitPrice: productGroup.product.price)
            $0.totalAmount.totalSavings = $0.productGroups.map { $0.savings }.reduce(0,+)
        }
    }
    
    func test_showAlert_shouldSetShouldShowBuyDialogToTrue() {
        let store = TestStore(
            initialState: CheckoutListDomain.State(),
            reducer: CheckoutListDomain.reducer,
            environment: CheckoutListDomain.Environment()
        )
        
        store.send(.showAlert) {
            $0.shouldShowBuyDialog = true
        }
    }
    
    func test_dismissAlert_shouldSetShouldShowBuyDialogToFalse() {
        let store = TestStore(
            initialState: CheckoutListDomain.State(),
            reducer: CheckoutListDomain.reducer,
            environment: CheckoutListDomain.Environment()
        )
        
        store.send(.showAlert) {
            $0.shouldShowBuyDialog = true
        }
        
        store.send(.dismissAlert) {
            $0.shouldShowBuyDialog = false
        }
    }
}
