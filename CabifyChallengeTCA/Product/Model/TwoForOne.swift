//
//  TwoForOne.swift
//  CabifyChallenge
//
//  Created by Marco Siracusano on 02/02/2023.
//

import Foundation

struct TwoForOne: Discount {
    var description: String = "Buy 1 get 1 free"
    
    func applyDiscount(quantity: Int, unitPrice: Double) -> Double {
        if quantity % 2 == 0 {
            return Double(quantity) * unitPrice / 2
        } else {
            return (Double(quantity - 1) * unitPrice / 2) + unitPrice
        }
    }
    
    func discountDoesApply(quantity: Int, unitPrice: Double) -> Bool {
        quantity > 1
    }
}
