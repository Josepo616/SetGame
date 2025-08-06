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
            let gridItemSizeCalculated = calculateGridItemSize(visibleCards: visibleCards, geometry: geometry)

            ScrollView(.vertical) {
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: gridItemSizeCalculated), spacing: 8)],
                    spacing: 8
                ) {
                    ForEach(visibleCards) { card in
                        cardView(for: card, size: gridItemSizeCalculated)
                    }
                }
                .padding(8)
            }
            .scrollDisabled(!shouldScroll)
        }
    }

    // MARK: - Helpers

    private func calculateGridItemSize(visibleCards: [Card], geometry: GeometryProxy) -> CGFloat {
        visibleCards.count >= 30
            ? 80.0
            : viewModel.gridItemWidthThatFits(
                count: visibleCards.count,
                size: geometry.size,
                atAspectRatio: 1 / 3
            )
    }
    
    @ViewBuilder
    private func cardView(for card: Card, size: CGFloat) -> some View {
        ShapeItemView(shape: card, viewModel: viewModel)
            .frame(width: size, height: size / (2 / 3))
            .matchedGeometryEffect(id: card.id, in: viewModel.cards.filter {$0.isMatched}.isEmpty ? dealingNamespace : matchingNamespace)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 2)
            .onTapGesture {
                viewModel.choose(card)
                if viewModel.validSet {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        viewModel.insertMatchedCards(viewModel.cards.filter {$0.isMatched} )
                        viewModel.updateCardsMatched()
                    }
                }
                viewModel.flipCardsOnScreen()
                print(viewModel.cardsMatched)
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
                            .frame(width: 60, height: 90)
                            .cornerRadius(10)
                            .padding(2)
                            .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.8)) {
                                    for _ in 0..<3 {
                                        viewModel.addMoreCards(1)  
                                    }
                                }
                                viewModel.flipCardsOnScreen()
                            }
                    }
                }
                .frame(
                    width:  80,
                    height: 80 / (2 / 3)
                )
            }
        }
    }

    var matchedCards: some View {
        let reversedCards = Array(viewModel.cardsMatched.reversed())
        return ZStack {
            ForEach(reversedCards, id: \.id) { card in
                ShapeItemView(shape: card, viewModel: viewModel)
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
