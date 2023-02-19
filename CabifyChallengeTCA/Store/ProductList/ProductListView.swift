//
//  ProductListView.swift
//  CabifyChallengeTCA
//
//  Created by Marco Siracusano on 18/02/2023.
//

import SwiftUI
import ComposableArchitecture

struct ProductListView: View {
    let store: Store<ProductListDomain.State, ProductListDomain.Action>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationStack {
                List {
                    ForEachStore(store.scope(state: \.productList,
                                             action: ProductListDomain.Action.product(id:action:))) {
                        ProductCell(store: $0)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Cabify Store")
                .onAppear {
                    viewStore.send(.onAppear)
                }
                .refreshable {
                    viewStore.send(.fetchProducts)
                }
                
                Spacer()
                
                ChooseProductButton(store: self.store.scope(state: \.chooseProductButton,
                                                       action: ProductListDomain.Action.chooseProductButton))
                
                .navigationDestination(isPresented: viewStore.binding(get: \.shouldGoToCheckout,
                                                                      send: ProductListDomain.Action.goToCheckout(isPushed:))) {
                    CheckoutList(store: Store(initialState: viewStore.checkoutList,
                                              reducer: CheckoutListDomain.reducer,
                                              environment: CheckoutListDomain.Environment()))
                }
            }
            .tint(.moradul)
        }
    }
}

struct ProductSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView(store: Store(initialState: ProductListDomain.State(),
                                          reducer: ProductListDomain.reducer,
                                          environment: ProductListDomain.Environment()))
    }
}
