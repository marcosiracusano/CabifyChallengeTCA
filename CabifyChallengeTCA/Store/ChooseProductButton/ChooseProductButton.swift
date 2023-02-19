//
//  CheckoutButton.swift
//  CabifyChallengeTCA
//
//  Created by Marco Siracusano on 19/02/2023.
//

import SwiftUI
import ComposableArchitecture

struct ChooseProductButton: View {
    let store: Store<ChooseProductButtonDomain.State, ChooseProductButtonDomain.Action>

    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                Button {
                    viewStore.send(.goToCheckout)
                } label: {
                    Text("Go to Checkout")
                }
                .buttonStyle(.checkout)
                .disabled(!viewStore.shouldShowCheckoutButton)
                .animation(.easeIn(duration: 0.2), value: viewStore.shouldShowCheckoutButton)
                
                HStack {
                    Spacer()
                    
                    if !viewStore.totalPrice.isZero {
                        Text(viewStore.totalPrice.euroFormattedString)
                            .font(.custom("Helvetica Neue", size: 14))
                            .foregroundColor(.white)
                            .padding(24)
                    }
                }
            }
        }
    }
}

struct CheckoutButton_Previews: PreviewProvider {
    static var previews: some View {
        ChooseProductButton(store: Store(initialState: ChooseProductButtonDomain.State(),
                                    reducer: ChooseProductButtonDomain.reducer,
                                    environment: ChooseProductButtonDomain.Environment()))
    }
}
