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
                
                Spacer()
                
                if viewStore.state.shouldShowCheckoutButton {
                    Button {
                        viewStore.send(.goToCheckout)
                    } label: {
                        HStack {
                            Spacer()
                            
                            Text("Go to Checkout")
                                .font(.custom("Helvetica Neue", size: 16))
                                .fontWeight(.medium)
                            
                            Spacer()
                        }
                        .padding(16)
                        .background(Color.moradul)
                        .foregroundColor(.white)
                        .cornerRadius(.infinity)
                        .shadow(radius: 10)
                        .padding()
                    }
                } else {
                    Text("Choose your product")
                        .font(.custom("Helvetica Neue", size: 16))
                        .fontWeight(.medium)
                        .background(.white)
                        .foregroundColor(.moradul)
                        .padding(.bottom, 30)
                }
            }
        }
    }
}

struct ProductSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView(store: Store(initialState: ProductListDomain.State(),
                                          reducer: ProductListDomain.reducer,
                                          environment: ProductListDomain.Environment(fetchProducts: {
            MockFactory.createProductArray(id: .tshirt, quantity: 3)
        })))
    }
}
