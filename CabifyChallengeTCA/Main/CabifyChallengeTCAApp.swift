//
//  CabifyChallengeTCAApp.swift
//  CabifyChallengeTCA
//
//  Created by Marco Siracusano on 17/02/2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct CabifyChallengeTCAApp: App {
    var body: some Scene {
        WindowGroup {
            ProductSelectionView(store: Store(initialState: ProductSelectionDomain.State(),
                                              reducer: ProductSelectionDomain.reducer,
                                              environment: ProductSelectionDomain.Environment(fetchProducts: {
                MockFactory.createProductArray(id: .tshirt, quantity: 3)
            })))
        }
    }
}
