//
//  CardView.swift
//  SetGame
//
//  Created by JoseAlvarez on 8/4/25.
//

import SwiftUI

extension SetGameView {
    // MARK: View: Cards remaining
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

    private func cardViewRemaining(for card: Card) -> some View {
        ShapeItemView(viewModel: viewModel, shape: card)
            .frame(width: 60, height: 90)
            .cornerRadius(10)
            .padding(2)
            .matchedGeometryEffect(id: card.id, in: dealingNamespace)
            .onTapGesture {
                handleCardTapRemaining(for: card)
            }
    }

    private func handleCardTapRemaining(for card: Card) {
        var tryMatchInCardsRemaining: Bool = false
        if viewModel.cardsOnScreen.filter({ $0.isSelected }).count == 3 {
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
            tryMatchInCardsRemaining = true
        }
        if tryMatchInCardsRemaining {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    for _ in 0..<3 {
                        viewModel.addMoreCards(1)
                    }
                    viewModel.flipCardsOnScreen()
                }
            }
        } else {
            withAnimation(.easeInOut(duration: 0.8)) {
                for _ in 0..<3 {
                    viewModel.addMoreCards(1)
                }
            }
        }
        viewModel.flipCardsOnScreen()
    }
}
