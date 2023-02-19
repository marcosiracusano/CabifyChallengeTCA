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
        WithViewStore(store) { viewStore in
            NavigationStack {
                List {
                    ForEachStore(store.scope(state: \.productList,
                                             action: ProductListDomain.Action.product(id:action:))) {
                        ProductCell(store: $0)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Cabify Store")
                .task {
                    viewStore.send(.fetchProducts)
                }
                .refreshable {
                    viewStore.send(.fetchProducts)
                }
                
                Spacer()
                
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
                .navigationDestination(isPresented: viewStore.binding(get: \.shouldGoToCheckout, send: .goToCheckout)) {
                    CheckoutList(store: Store(initialState: viewStore.checkoutCartState,
                                              reducer: CheckoutListDomain.reducer,
                                              environment: CheckoutListDomain.Environment()))
                }
            }
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
