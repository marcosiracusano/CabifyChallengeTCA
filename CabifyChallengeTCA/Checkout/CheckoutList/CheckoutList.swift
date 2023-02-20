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
                    
                    TotalAmountView(store: store.scope(state: \.totalAmount,
                                                       action: CheckoutListDomain.Action.totalAmount))
                }
                .listStyle(.plain)
                .scrollDisabled(true)
                
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
                Text("You made a purchase of \(viewStore.totalAmount.totalPrice.euroFormattedString).")
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
