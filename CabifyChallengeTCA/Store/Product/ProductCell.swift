//
//  ProductCell.swift
//  CabifyChallengeTCA
//
//  Created by Marco Siracusano on 18/02/2023.
//

import SwiftUI
import ComposableArchitecture

struct ProductCell: View {
    let store: Store<ProductDomain.State, ProductDomain.Action>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack {
                Image(systemName: viewStore.product.id.iconImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.moradul)
                    .frame(width: 70, height: 70)
                
                VStack(alignment: .leading) {
                    Text(viewStore.product.name)
                        .font(.custom("Helvetica Neue", size: 16))
                        .fontWeight(.medium)
                        .padding(.bottom, 5)
                    
                    Text(viewStore.product.price.euroFormattedString)
                        .font(.custom("Helvetica Neue", size: 14))
                        .padding(.bottom, 5)
                    
                    Text(viewStore.product.discount?.description ?? "")
                        .font(.custom("Helvetica Neue Italic", size: 10))
                }
                .padding(.leading, 16)
                
                Spacer()
                
                PlusMinusButton(store: self.store.scope(state: \.plusMinusState,
                                                        action: ProductDomain.Action.tapButton))
            }
            .padding(.init(top: 16, leading: 0, bottom: 16, trailing: 0))
        }
    }
}

struct ProductCell_Previews: PreviewProvider {
    static var previews: some View {
        ProductCell(store: Store(initialState: ProductDomain.State(id: UUID(),
                                                                   product: MockFactory.getProduct(.tshirt)!),
                                 reducer: ProductDomain.reducer,
                                 environment: ProductDomain.Environment()))
    }
}
