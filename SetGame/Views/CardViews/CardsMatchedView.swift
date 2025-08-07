//
//  CardsMatchedView.swift
//  SetGame
//
//  Created by JoseAlvarez on 8/7/25.
//

import SwiftUI

extension SetGameView {
    // MARK: View: Cards matched
    var matchedCards: some View {
        let reversedCards = Array(viewModel.cardsMatched.reversed())
        return ZStack {
            ForEach(reversedCards, id: \.id) { card in
                ShapeItemView(viewModel: viewModel, shape: card)
                    .frame(width: 60, height: 90)
                    .cornerRadius(10)
                    .matchedGeometryEffect(id: card.id, in: matchingNamespace)
                    .zIndex(
                        Double(
                            reversedCards.count
                                - (reversedCards.firstIndex(of: card) ?? 0)
                        )
                    )
                    .padding(2)
                    .onAppear {
                        viewModel.flipCardsOnScreen()
                    }
            }
        }
        .frame(width: 60, height: 95)
    }
}
