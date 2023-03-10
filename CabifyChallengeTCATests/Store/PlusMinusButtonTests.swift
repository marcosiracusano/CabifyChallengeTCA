//
//  PlusMinusButtonTests.swift
//  CabifyChallengeTCATests
//
//  Created by Marco Siracusano on 20/02/2023.
//

import XCTest
import ComposableArchitecture
@testable import CabifyChallengeTCA

final class PlusMinusButtonTests: XCTestCase {

    func test_didTapPlusButton_shouldIncrementCountByOne() {
        let store = TestStore(
            initialState: PlusMinusButtonDomain.State(),
            reducer: PlusMinusButtonDomain.reducer,
            environment: PlusMinusButtonDomain.Environment()
        )
        
        let initialCount = store.state.count
        
        store.send(.didTapPlusButton) {
            $0.count = initialCount + 1
        }
    }
    
    func test_didTapMinusButton_shouldDecreaseCountByOne() {
        let store = TestStore(initialState: PlusMinusButtonDomain.State(),
                              reducer: PlusMinusButtonDomain.reducer,
                              environment: PlusMinusButtonDomain.Environment())
        
        let initialCount = store.state.count
        
        store.send(.didTapMinusButton) {
            $0.count = initialCount - 1
        }
    }
}
