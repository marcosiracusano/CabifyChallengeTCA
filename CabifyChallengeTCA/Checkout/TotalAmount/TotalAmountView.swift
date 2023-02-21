//
//  TotalAmountView.swift
//  CabifyChallengeTCA
//
//  Created by Marco Siracusano on 20/02/2023.
//

import SwiftUI
import ComposableArchitecture

struct TotalAmountView: View {
    let store: Store<TotalAmountDomain.State, TotalAmountDomain.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                HStack(alignment: .top) {
                    Spacer()
                    
                    Text("Total amount:")
                        .font(.custom("Helvetica Neue", size: 16))
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    Text(viewStore.totalPrice.euroFormattedString)
                        .font(.custom("Helvetica Neue", size: 16))
                        .fontWeight(.bold)
                }
                
                if !viewStore.totalSavings.isZero {
                    HStack(alignment: .top) {
                        Spacer()
                        
                        Text("You save:")
                            .font(.custom("Helvetica Neue", size: 14))
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        Text(viewStore.totalSavings.euroFormattedString)
                            .font(.custom("Helvetica Neue", size: 14))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 5)
                }
            }
            .padding(.vertical)
            .listRowSeparator(.hidden, edges: .bottom)
        }
    }
}

struct TotalAmount_Previews: PreviewProvider {
    static var previews: some View {
        TotalAmountView(
            store: Store(
                initialState: TotalAmountDomain.State(),
                reducer: TotalAmountDomain.reducer,
                environment: TotalAmountDomain.Environment()
            )
        )
    }
}
