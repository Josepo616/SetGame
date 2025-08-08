//
//  CardsOnScreenView.swift
//  SetGame
//
//  Created by JoseAlvarez on 8/7/25.
//

import SwiftUI

/// Displays all visible cards in a responsive grid,
/// adjusting layout and scroll behavior dynamically.
extension SetGameView {
    var cards: some View {
        GeometryReader { geometry in
            let visibleCards = viewModel.cardsOnScreen
            let shouldScroll = visibleCards.count >= 30
            let gridItemSizeCalculated = calculateGridItemSize(
                visibleCards: visibleCards,
                geometry: geometry
            )

            ScrollView(.vertical) {
                LazyVGrid(
                    columns: [
                        GridItem(
                            .adaptive(minimum: gridItemSizeCalculated),
                            spacing: 8
                        )
                    ],
                    spacing: 8
                ) {
                    ForEach(visibleCards) { card in
                        cardsOnScreenView(
                            for: card,
                            size: gridItemSizeCalculated
                        )
                    }
                }
                .padding(8)
            }
            .scrollDisabled(!shouldScroll)
        }
    }

    // MARK: Helpers for screen cards
    /// Calculates dynamic card sizes and builds each card view
    /// with animations, effects, and tap interactions.
    private func calculateGridItemSize(
        visibleCards: [Card],
        geometry: GeometryProxy
    ) -> CGFloat {
        visibleCards.count >= 30
            ? 80.0
            : viewModel.gridItemWidthThatFits(
                count: visibleCards.count,
                size: geometry.size,
                atAspectRatio: 1 / 3
            )
    }

    @ViewBuilder
    private func cardsOnScreenView(for card: Card, size: CGFloat) -> some View {
        let isZoomed = zoomedCardIDs.contains(card.id)
        let isShaking = shakingCardIDs.contains(card.id)

        CardsItemView(viewModel: viewModel, shape: card)
            .frame(width: size, height: size / (2 / 3))
            .scaleEffect(isZoomed ? 4 : 1)
            .modifier(ShakeEffect(animatableData: isShaking ? 1 : 0))
            .matchedGeometryEffect(
                id: card.id,
                in: viewModel.cardsOnScreen.filter { $0.isMatched }.isEmpty
                    ? dealingNamespace : matchingNamespace
            )
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 2)
            .onTapGesture {
                viewModel.choose(card)
                AnimationView.makeAnimations(
                    viewModel: viewModel,
                    zoomedCardIDs: $zoomedCardIDs,
                    shakingCardIDs: $shakingCardIDs
                )
                viewModel.flipCardsOnScreen()
            }
    }
}
