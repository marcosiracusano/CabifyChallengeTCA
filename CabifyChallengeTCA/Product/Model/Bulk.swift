//
//  Bulk.swift
//  CabifyChallenge
//
//  Created by Marco Siracusano on 02/02/2023.
//

import Foundation

struct Bulk: Discount {
    var description: String
    var bulkLimit: Int
    var discountPrice: Double
    
    init(bulkLimit: Int, discountPrice: Double) {
        self.description = "Buy \(bulkLimit) or more at " + discountPrice.euroFormattedString + " per unit"
        self.bulkLimit = bulkLimit
        self.discountPrice = discountPrice
    }
    
    func applyDiscount(quantity: Int, unitPrice: Double) -> Double {
        if quantity >= bulkLimit {
            return Double(quantity) * discountPrice
        } else {
            return Double(quantity) * unitPrice
        }
    }
    
    func discountDoesApply(quantity: Int, unitPrice: Double) -> Bool {
        quantity >= bulkLimit
    }
}
