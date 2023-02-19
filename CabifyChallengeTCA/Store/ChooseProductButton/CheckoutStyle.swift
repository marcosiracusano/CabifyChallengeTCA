//
//  CheckoutStyle.swift
//  CabifyChallengeTCA
//
//  Created by Marco Siracusano on 18/02/2023.
//

import SwiftUI

struct CheckoutStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        if isEnabled {
            HStack {
                Spacer()
                
                configuration.label
                    .font(.custom("Helvetica Neue", size: 16))
                    .fontWeight(.medium)
                
                Spacer()
            }
            .padding(16)
            .background(Color.moradul)
            .foregroundColor(.white)
            .cornerRadius(.infinity)
            .shadow(radius: 10)
            .shadow(radius: 10)
            .padding()
        } else {
            Text("Choose your product")
                .font(.custom("Helvetica Neue", size: 16))
                .fontWeight(.medium)
                .background(.clear)
                .foregroundColor(.moradul)
                .padding(30)
        }
    }
}

extension ButtonStyle where Self == CheckoutStyle {
  static var checkout: CheckoutStyle { .init() }
}
