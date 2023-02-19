//
//  ProductGroupCell.swift
//  CabifyChallengeTCA
//
//  Created by Marco Siracusano on 18/02/2023.
//

import SwiftUI
import ComposableArchitecture

struct ProductGroupCell: View {
    let store: Store<ProductGroupDomain.State, ProductGroupDomain.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            HStack {
                Text("\(viewStore.state.productGroup.quantity) x \(viewStore.state.productGroup.product.name)")
                    .font(.custom("Helvetica Neue", size: 16))
                    .fontWeight(.medium)
                
                Spacer()
                
                Text(viewStore.state.productGroup.product.price.euroFormattedString)
                    .font(.custom("Helvetica Neue", size: 16))
                    .fontWeight(.bold)
            }
            .padding(.vertical)
        }
    }
}

struct ProductGroupCell_Previews: PreviewProvider {
    static var previews: some View {
        ProductGroupCell(store: Store(initialState: ProductGroupDomain.State(id: UUID(),
                                                                             productGroup: MockFactory.voucherProductGroupExample),
                                      reducer: ProductGroupDomain.reducer,
                                      environment: ProductGroupDomain.Environment()))
    }
}
