//
//  ProductSelectionView.swift
//  CabifyChallengeTCA
//
//  Created by Marco Siracusano on 18/02/2023.
//

import SwiftUI
import ComposableArchitecture

struct ProductSelectionView: View {
    let store: Store<ProductSelectionDomain.State, ProductSelectionDomain.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationStack {
                List {
                    ForEachStore(store.scope(state: \.productList,
                                             action: ProductSelectionDomain.Action.product(id:action:))) {
                        ProductCell(store: $0)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Cabify Store")
                .task {
                    viewStore.send(.fetchProducts)
                }
            }
        }
    }
}

struct ProductSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ProductSelectionView(store: Store(initialState: ProductSelectionDomain.State(),
                                          reducer: ProductSelectionDomain.reducer,
                                          environment: ProductSelectionDomain.Environment(fetchProducts: {
            MockFactory.createProductArray(id: .tshirt, quantity: 3)
        })))
    }
}
