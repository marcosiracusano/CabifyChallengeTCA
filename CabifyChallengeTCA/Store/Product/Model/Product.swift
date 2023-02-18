//
//  Product.swift
//  CabifyChallenge
//
//  Created by Marco Siracusano on 31/01/2023.
//

import Foundation

enum ProductId: String, Decodable, CaseIterable {
    case voucher, tshirt, mug, unknown
    
    var iconImageName: String {
        switch self {
        case .voucher:
            return "ticket.fill"
        case .tshirt:
            return "tshirt.fill"
        case .mug:
            return "mug.fill"
        case .unknown:
            return "questionmark.app"
        }
    }
}

struct Product: Decodable, Equatable {
    var code: String
    var name: String
    var price: Double
    var id: ProductId {
        ProductId.allCases.filter { $0.rawValue == self.code.lowercased() }.first ?? .unknown
    }
    var discount: Discount? {
        switch id {
        case .voucher:
            return TwoForOne()
        case .tshirt:
            return Bulk(bulkLimit: 3, discountPrice: 19)
        default:
            return nil
        }
    }
}
