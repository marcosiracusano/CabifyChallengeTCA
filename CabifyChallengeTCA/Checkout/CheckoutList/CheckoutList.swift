//
//  CheckoutList.swift
//  CabifyChallengeTCA
//
//  Created by Marco Siracusano on 18/02/2023.
//

import SwiftUI
import ComposableArchitecture

struct CheckoutList: View {
    let store: Store<CheckoutListDomain.State, CheckoutListDomain.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationStack {
                List {
                    ForEachStore(store.scope(state: \.productGroups,
                                             action: CheckoutListDomain.Action.productGroup(id:action:))) {
                        ProductGroupCell(store: $0)
                    }
                    
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
                }
                .listStyle(.plain)
                
                Button {
                    viewStore.send(.showAlert)
                } label: {
                    Text("Buy")
                }
                .buttonStyle(.checkout)
            }
            .navigationTitle("Checkout")
            .alert("Thank you", isPresented: viewStore.binding(get: \.shouldShowBuyDialog,
                                                               send: CheckoutListDomain.Action.dismissAlert)) {
            } message: {
                Text("You made a purchase of \(viewStore.totalPrice.euroFormattedString).")
            }
        }
    }
}

struct CheckoutList_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutList(
            store: Store(initialState: CheckoutListDomain.State(productGroups: IdentifiedArray(uniqueElements: [ProductGroupDomain.State(id: UUID(), productGroup: MockFactory.voucherProductGroupExample), ProductGroupDomain.State(id: UUID(), productGroup: MockFactory.voucherProductGroupExample)])),
                         reducer: CheckoutListDomain.reducer,
                         environment: CheckoutListDomain.Environment())
        )
    }
}
