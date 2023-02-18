//
//  ProductGroupDomain.swift
//  CabifyChallengeTCA
//
//  Created by Marco Siracusano on 18/02/2023.
//

import Foundation
import ComposableArchitecture

struct ProductGroupDomain {
    
    struct State: Equatable, Identifiable {
        var id: UUID
        var productGroup: ProductGroup
    }
    
    enum Action: Equatable {}
    
    struct Environment {}
    
    static let reducer = AnyReducer<State, Action, Environment>
        .combine(
            
        )
}
