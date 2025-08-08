//
//  CardView.swift
//  SetGame
//
//  Created by JoseAlvarez on 8/4/25.
//

import SwiftUI

/// Displays the stack of remaining cards in the deck,
/// ready for dealing with proper sizing and layout.
extension SetGameView {
    var remainingCards: some View {
        Group {
            if !viewModel.cardsRemaining.isEmpty {
                ZStack {
                    ForEach(viewModel.cardsRemaining) { card in
                        cardViewRemaining(for: card)
                    }
                }
                .frame(width: 80, height: 80 / (2 / 3))
            }
        }
    }

    // MARK: Helpers for the remaining cards
    /// Handles interactions and animations for the deck's
    /// remaining cards, including dealing and set checks.
    public func handleCardTapRemaining(for card: Card) {
        var tryMatchInCardsRemaining: Bool = false
        if viewModel.cardsOnScreen.filter({ $0.isSelected }).count == 3 {
            tryMatchInCardsRemaining = tryMakeSetInCardsRemaining()
        }
        if tryMatchInCardsRemaining {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                AnimationView.dealCardsAnimation(3, viewModel)
            }
        } else {
            AnimationView.dealCardsAnimation(3, viewModel)
        }
        if viewModel.tryCreateNewGame {
            AnimationView.dealCardsAnimation(12, viewModel)
            viewModel.tryCreateNewGame = false
        }
        viewModel.flipCardsOnScreen()
    }

    private func tryMakeSetInCardsRemaining() -> Bool {
        if let lastUnselectedCard = viewModel.cardsOnScreen.filter({
            !$0.isSelected
        }).last {
            viewModel.choose(lastUnselectedCard)
        }
        if viewModel.validSet == true {
            AnimationView.makeAnimations(
                viewModel: viewModel,
                zoomedCardIDs: $zoomedCardIDs,
                shakingCardIDs: $shakingCardIDs
            )
        } else if viewModel.validSet == false {
            AnimationView.makeAnimations(
                viewModel: viewModel,
                zoomedCardIDs: $zoomedCardIDs,
                shakingCardIDs: $shakingCardIDs
            )
        }
        return true
    }

    private func cardViewRemaining(for card: Card) -> some View {
        CardsItemView(viewModel: viewModel, shape: card)
            .frame(width: 60, height: 90)
            .cornerRadius(10)
            .padding(2)
            .matchedGeometryEffect(id: card.id, in: dealingNamespace)
            .onTapGesture {
                handleCardTapRemaining(for: card)
            }
    }
}
