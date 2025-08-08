//
//  AnimationView.swift
//  SetGame
//
//  Created by JoseAlvarez on 8/7/25.
//

import SwiftUI

// MARK: Animations by default
/// Handles card animations for matches, mismatches,
/// and dealing new cards with smooth visual effects.
struct AnimationView {
    static func makeAnimations(
        viewModel: SetGameViewModel,
        zoomedCardIDs: Binding<Set<UUID>>,
        shakingCardIDs: Binding<Set<UUID>>
    ) {
        if viewModel.validSet == true {
            viewModel.abbleToTouch = false
            let matched = viewModel.cardsOnScreen.filter { $0.isMatched }
            let ids = matched.map(\.id)

            withAnimation(.easeInOut(duration: 1)) {
                zoomedCardIDs.wrappedValue.formUnion(ids)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.easeInOut(duration: 1)) {
                    zoomedCardIDs.wrappedValue.subtract(ids)
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        viewModel.insertMatchedCards(matched)
                        viewModel.updateCardsMatched()
                        viewModel.flipCardsOnScreen()
                        viewModel.abbleToTouch = true
                    }
                }
            }
        } else if viewModel.validSet == false {
            let selected = viewModel.cardsOnScreen.filter { $0.isSelected }
            let ids = selected.map(\.id)

            withAnimation(.default) {
                shakingCardIDs.wrappedValue.formUnion(ids)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.default) {
                    shakingCardIDs.wrappedValue.subtract(ids)
                }
            }
        }
    }

    static func dealCardsAnimation(
        _ amountOfCards: Int,
        _ viewModel: SetGameViewModel
    ) {
        withAnimation(.easeInOut(duration: 0.8)) {
            for _ in 0..<amountOfCards {
                viewModel.addMoreCards(1)
                viewModel.flipCardsOnScreen()
            }
        }
    }
}

// MARK: - Custom Animations
/// A custom ViewModifier that applies a horizontal shake
/// animation, useful for indicating incorrect selections.
struct ShakeEffect: GeometryEffect {
    var travelDistance: CGFloat = 8
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(
            CGAffineTransform(
                translationX:
                    travelDistance
                    * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                y: 0
            )
        )
    }
}
