//
//  Extensions.swift
//  CabifyChallenge
//
//  Created by Marco Siracusano on 01/02/2023.
//

import UIKit
import SwiftUI

extension Double {
    var euroFormattedString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "eur"
        formatter.maximumFractionDigits = 2
        
        let number = NSNumber(value: self)
        
        return formatter.string(from: number) ?? "€--"
    }
}

extension Color {
    static var moradul: Color {
        Color(red: 113/255, green: 69/255, blue: 214/255)
    }
}
