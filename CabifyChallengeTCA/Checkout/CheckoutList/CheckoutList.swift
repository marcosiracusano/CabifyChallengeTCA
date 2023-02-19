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
        WithViewStore(self.store) { viewStore in
            VStack {
                List {
                    ForEachStore(store.scope(state: \.productGroups,
                                             action: CheckoutListDomain.Action.productGroup(id:action:))) {
                        ProductGroupCell(store: $0)
                    }
                    
                    HStack(alignment: .top) {
                        Spacer()
                        
                        Text("Total amount:")
                            .font(.custom("Helvetica Neue", size: 16))
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        Text(viewStore.totalAmount.euroFormattedString)
                            .font(.custom("Helvetica Neue", size: 16))
                            .fontWeight(.bold)
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
            .alert("Thank you", isPresented: viewStore.binding(get: \.shouldShowBuyDialog,
                                                               send: CheckoutListDomain.Action.dismissAlert)) {
            } message: {
                Text("You made a purchase of \(viewStore.totalAmount.euroFormattedString).")
            }
        }
    }
}

struct CheckoutList_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutList(
            store: Store(initialState: CheckoutListDomain.State(productGroups: IdentifiedArray(uniqueElements: [ProductGroupDomain.State(id: UUID(), productGroup: MockFactory.voucherProductGroupExample), ProductGroupDomain.State(id: UUID(), productGroup: MockFactory.voucherProductGroupExample)]), totalAmount: 0),
                         reducer: CheckoutListDomain.reducer,
                         environment: CheckoutListDomain.Environment())
        )
    }
}
