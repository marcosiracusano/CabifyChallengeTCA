//
//  Discount.swift
//  CabifyChallenge
//
//  Created by Marco Siracusano on 01/02/2023.
//

import Foundation

protocol Discount: Equatable {
    var description: String { get }
    func applyDiscount(quantity: Int, unitPrice: Double) -> Double
    func discountDoesApply(quantity: Int, unitPrice: Double) -> Bool
}
