//
//  MockFactory.swift
//  CabifyChallengeTests
//
//  Created by Marco Siracusano on 02/02/2023.
//

import Foundation

class MockFactory {
    
    static private let voucherProduct = Product(code: "VOUCHER", name: "Cabify Voucher", price: 5)
    static private let tshirtProduct = Product(code: "TSHIRT", name: "Cabify T-Shirt", price: 20)
    static private let mugProduct = Product(code: "MUG", name: "Cabify Coffee Mug", price: 7.5)
    
    static func getProduct(_ id: ProductId) -> Product? {
        switch id {
        case .voucher:
            return voucherProduct
        case .tshirt:
            return tshirtProduct
        case .mug:
            return mugProduct
        case .unknown:
            return nil
        }
    }
    
    static func createProductArray(id: ProductId, quantity: Int) -> [Product] {
        Array(repeating: getProduct(id), count: quantity).compactMap {$0}
    }
}
