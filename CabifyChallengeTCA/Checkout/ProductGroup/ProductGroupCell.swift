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
                Text("\(viewStore.productGroup.quantity) x \(viewStore.productGroup.product.name)")
                    .font(.custom("Helvetica Neue", size: 16))
                    .fontWeight(.medium)
                
                Spacer()
                
                if viewStore.shouldShowStrikethroughPrice {
                    Text(viewStore.fullPrice.euroFormattedString)
                        .font(.custom("Helvetica Neue", size: 14))
                        .foregroundColor(.gray)
                        .strikethrough()
                        .padding(.horizontal)
                }
                
                Text(viewStore.discountedPrice.euroFormattedString)
                    .font(.custom("Helvetica Neue", size: 16))
                    .fontWeight(.bold)
            }
            .padding(.vertical)
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

struct ProductGroupCell_Previews: PreviewProvider {
    static var previews: some View {
        ProductGroupCell(
            store: Store(
                initialState: ProductGroupDomain.State(
                    id: UUID(),
                    productGroup: MockFactory.voucherProductGroupExample
                ),
                reducer: ProductGroupDomain.reducer,
                environment: ProductGroupDomain.Environment()
            )
        )
    }
}
