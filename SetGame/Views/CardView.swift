//
//  CardView.swift
//  SetGame
//
//  Created by JoseAlvarez on 8/4/25.
//

import SwiftUI

extension SetGameView {
    var cards: some View {
        GeometryReader { geometry in
            let visibleCards = viewModel.cards
            let shouldScroll = visibleCards.count >= 30
            let gridItemSize =
                shouldScroll
                ? 80.0
                : viewModel.gridItemWidthThatFits(
                    count: visibleCards.count,
                    size: geometry.size,
                    atAspectRatio: 1 / 3
                )

            ScrollView(.vertical) {
                LazyVGrid(
                    columns: [
                        GridItem(.adaptive(minimum: gridItemSize), spacing: 8)
                    ],
                    spacing: 8
                ) {
                    ForEach(visibleCards) { cards in
                        ShapeItemView(shape: cards, viewModel: viewModel)
                            .frame(
                                width: gridItemSize,
                                height: gridItemSize / (2 / 3)
                            )
                            .matchedGeometryEffect(
                                id: cards.id,
                                in: dealAnimation
                            )
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                            .onTapGesture {
                                viewModel.choose(cards)
                                viewModel.flipCardsOnScreen()
                            }

                    }
                }
                .padding(8)
            }
            .scrollDisabled(!shouldScroll)
        }
    }
}

extension SetGameView {

    var remainingCards: some View {
        Group {
            if !viewModel.cardsRemaining.isEmpty {
                ZStack {
                    ForEach(viewModel.cardsRemaining) { card in
                        ShapeItemView(shape: card, viewModel: viewModel)
                            .matchedGeometryEffect(
                                id: card.id,
                                in: dealAnimation
                            )
                            .frame(width: 60, height: 90)
                            .cornerRadius(10)
                            //.zIndex(Double(viewModel.cardsRemaining.count - (viewModel.cardsRemaining.firstIndex(of: card) ?? 0)))
                            .padding(2)

                    }
                }
                .offset(y: viewModel.activeAnimation ? -500 : 0)  // Desplazamiento en Y
                .animation(
                    .easeInOut(duration: 1),
                    value: viewModel.activeAnimation
                )  // Control de animación
                .onTapGesture {
                    // Inicia la animación de desplazamiento
                    withAnimation(.easeInOut(duration: 1)) {
                        viewModel.activeAnimation = true
                        viewModel.addMoreCards(3)
                    }
                    viewModel.flipCardsOnScreen()
                }
                .frame(width: 60, height: 95)
            }
        }
    }

    var matchedCards: some View {
        let reversedCards = Array(viewModel.cardsMatched.reversed())  // Crear una copia invertida

        return ZStack {
            ForEach(reversedCards, id: \.id) { card in
                ShapeItemView(shape: card, viewModel: viewModel)
                    .frame(width: 60, height: 90)
                    .cornerRadius(10)
                    .zIndex(
                        Double(
                            reversedCards.count
                                - (reversedCards.firstIndex(of: card) ?? 0)
                        )
                    )
                    .padding(2)
                    .onTapGesture {
                        print(reversedCards)
                    }
            }
        }
        .frame(width: 60, height: 95)
    }

}
