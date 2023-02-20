//
//  TotalAmountDomain.swift
//  CabifyChallengeTCA
//
//  Created by Marco Siracusano on 20/02/2023.
//

import Foundation
import ComposableArchitecture

struct TotalAmountDomain {
    struct State: Equatable {
        var totalPrice = 0.0
        var totalSavings = 0.0
    }
    
    enum Action: Equatable {}
    
    struct Environment {}
    
    static let reducer = AnyReducer<State, Action, Environment> { _ in }
}
