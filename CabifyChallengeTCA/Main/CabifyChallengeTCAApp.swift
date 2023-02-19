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
            ProductListView(store: Store(initialState: ProductListDomain.State(),
                                              reducer: ProductListDomain.reducer,
                                              environment: ProductListDomain.Environment()))
        }
    }
}
