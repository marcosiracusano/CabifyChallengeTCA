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
            PlusMinusButton(store: Store(initialState: AddToCartDomain.State(),
                                         reducer: AddToCartDomain.reducer,
                                         environment: AddToCartDomain.Environment()))
        }
    }
}
