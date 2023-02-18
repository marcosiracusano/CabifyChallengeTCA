//
//  CheckoutDomain.swift
//  CabifyChallengeTCA
//
//  Created by Marco Siracusano on 18/02/2023.
//

import Foundation
import ComposableArchitecture

struct CheckoutListDomain {
    
    struct State: Equatable {
        var productGroups: IdentifiedArrayOf<ProductGroupDomain.State> = []
    }
    
    enum Action: Equatable {
        case buy
    }
    
    struct Environment {
        
    }
    
    static let reducer = AnyReducer<State, Action, Environment>
        .combine(
            
        )
}
