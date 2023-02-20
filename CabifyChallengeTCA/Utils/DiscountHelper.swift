//
//  DiscountHelper.swift
//  CabifyChallengeTCA
//
//  Created by Marco Siracusano on 20/02/2023.
//

import Foundation

struct DiscountHelper {
    static func getDiscount(id: ProductId) -> (any Discount)? {
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
