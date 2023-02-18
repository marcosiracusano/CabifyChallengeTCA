//
//  PlusMinusButton.swift
//  CabifyChallengeTCA
//
//  Created by Marco Siracusano on 18/02/2023.
//

import SwiftUI
import ComposableArchitecture

struct PlusMinusButton: View {
    let store: Store<PlusMinusDomain.State, PlusMinusDomain.Action>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack {
                if viewStore.count > 0 {
                    Button {
                        viewStore.send(.didTapMinusButton)
                    } label: {
                        Image(systemName: "minus.circle")
                            .foregroundColor(.moradul)
                            .imageScale(.large)
                    }
                    
                    Text(viewStore.count.description)
                        .font(.custom("Helvetica Neue", size: 18))
                        .fontWeight(.bold)
                        .padding(5)
                }
                
                Button {
                    viewStore.send(.didTapPlusButton)
                } label: {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.moradul)
                        .imageScale(.large)
                }
            }
        }
    }
}

struct PlusMinusButton_Previews: PreviewProvider {
    static var previews: some View {
        PlusMinusButton(store: Store(initialState: PlusMinusDomain.State(),
                                     reducer: PlusMinusDomain.reducer,
                                     environment: PlusMinusDomain.Environment()))
    }
}
