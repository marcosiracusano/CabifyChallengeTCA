//
//  PlusMinusButton.swift
//  CabifyChallengeTCA
//
//  Created by Marco Siracusano on 18/02/2023.
//

import SwiftUI
import ComposableArchitecture

struct PlusMinusButton: View {
    let store: Store<AddToCartDomain.State, AddToCartDomain.Action>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack {
                Button {
                    viewStore.send(.didTapMinusButton)
                } label: {
                    Text("-")
                        .padding(10)
                        .background(Color.moradul)
                        .foregroundColor(.white)
                        .cornerRadius(.infinity)
                }
                
                Text(viewStore.count.description)
                    .font(.custom("Helvetica Neue", size: 18))
                    .fontWeight(.bold)
                    .padding(5)
                
                Button {
                    viewStore.send(.didTapPlusButton)
                } label: {
                    Text("+")
                        .padding(10)
                        .background(Color.moradul)
                        .foregroundColor(.white)
                        .cornerRadius(.infinity)
                }
            }
        }
    }
}

struct PlusMinusButton_Previews: PreviewProvider {
    static var previews: some View {
        PlusMinusButton(store: Store(initialState: AddToCartDomain.State(),
                                     reducer: AddToCartDomain.reducer,
                                     environment: AddToCartDomain.Environment()))
    }
}
