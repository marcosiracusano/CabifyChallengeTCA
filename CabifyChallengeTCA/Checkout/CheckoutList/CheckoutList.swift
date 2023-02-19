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
            List {
                ForEachStore(store.scope(state: \.productGroups,
                                         action: CheckoutListDomain.Action.productGroup(id:action:))) {
                    ProductGroupCell(store: $0)
                }
            }
            .listStyle(.plain)
            .onDisappear {
                viewStore.send(.goBack)
            }
        }
    }
}

struct CheckoutList_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutList(store: Store(initialState: CheckoutListDomain.State(),
                                  reducer: CheckoutListDomain.reducer,
                                  environment: CheckoutListDomain.Environment()))
    }
}
