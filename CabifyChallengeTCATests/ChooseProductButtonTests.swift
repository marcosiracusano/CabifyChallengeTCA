//
//  ChooseProductButtonTests.swift
//  CabifyChallengeTCATests
//
//  Created by Marco Siracusano on 20/02/2023.
//

import XCTest
import ComposableArchitecture
@testable import CabifyChallengeTCA

final class ChooseProductButtonTests: XCTestCase {

    func test_goToCheckout_shouldNotModifyState() {
        let store = TestStore(
            initialState: ChooseProductButtonDomain.State(),
            reducer: ChooseProductButtonDomain.reducer,
            environment: ChooseProductButtonDomain.Environment()
        )
        
        store.send(.goToCheckout)
    }
}
