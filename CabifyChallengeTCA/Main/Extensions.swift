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

extension String {
    func strikethrough() -> NSAttributedString {
        var attributes = [NSAttributedString.Key : Any]()
        attributes[.strikethroughColor] = UIColor.systemGray
        attributes[.strikethroughStyle] = 1
        
        return NSAttributedString(string: self, attributes :attributes)
    }
}

extension UIView {
    func addShadows() {
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}

extension Color {
    static var moradul: Color {
        Color(red: 113/255, green: 69/255, blue: 214/255)
    }
}
