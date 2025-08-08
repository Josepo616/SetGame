//
//  SetViewModel.swift
//  SetGame
//
//  Created by JoseAlvarez on 7/28/25.
//

import SwiftUI

// MARK: - View model for Set Game
/// ViewModel connecting the Set game logic with SwiftUI views,
/// managing state updates, animations, and user interactions.
final class SetGameViewModel: ObservableObject {
    @Published private(set) var validSet: Bool? = nil
    @Published private(set) var cardsOnScreen: [Card]
    @Published private(set) var cardsRemaining: [Card]
    @Published private(set) var cardsMatched: [Card]
    private var setGame = SetGame()
    public var response = ""
    public var abbleToTouch: Bool = true
    public var tryCreateNewGame: Bool = false

    init(setGame: SetGame = SetGame()) {
        self.setGame = setGame
        self.cardsOnScreen = setGame.cardsOnScreen
        self.cardsRemaining = setGame.cardsRemaining
        self.cardsMatched = setGame.cardsMatched
    }

    func choose(_ card: Card) {
        if abbleToTouch {
            setGame.chooseAndMakeSet = setGame.choose(card)
        }
        if setGame.chooseAndMakeSet == true {
            self.validSet = true
        } else if setGame.chooseAndMakeSet == false {
            self.validSet = false
        } else {
            self.validSet = nil
        }
        response = setGame.showSetMaked()
        updateCardsOnScreen()
    }

    func insertMatchedCards(_ matchedCard: [Card]) {
        if self.validSet == true {
            addMatchedCards(matchedCard)
        }
    }

    func startNewGame() {
        setGame = SetGame()
        tryCreateNewGame = true
        self.cardsMatched.removeAll()
        updateCardsRemaining()
        updateCardsOnScreen()
        flipCardsOnScreen()
    }

    func addMoreCards(_ count: Int) {
        setGame.addMoreCards(count)
        updateCardsOnScreen()
        updateCardsRemaining()
    }

    func addMatchedCards(_ matched: [Card]) {
        setGame.addMatchedCards(matched)
        updateCardsOnScreen()
        self.cardsMatched = setGame.cardsRemaining
    }

    func flipCardsOnScreen() {
        for index in cardsOnScreen.indices {
            cardsOnScreen[index].isFlipped = false
        }
        if self.cardsMatched.count > 0 {
            for index in cardsMatched.indices {
                cardsMatched[index].isFlipped = false
            }
        }
    }

    func shuffleVisibleCards() {
        withAnimation(.easeInOut(duration: 1.6)) {
            setGame.shuffleCardsOnScreen()
        }
        updateCardsOnScreen()
        flipCardsOnScreen()
    }

    // MARK: Helpers
    /// Updates published properties to reflect the current
    /// game state from the underlying SetGame model.
    func updateCardsMatched() {
        self.cardsMatched = setGame.cardsMatched
    }

    func updateCardsOnScreen() {
        self.cardsOnScreen = setGame.cardsOnScreen
    }

    func updateCardsRemaining() {
        self.cardsRemaining = setGame.cardsRemaining
    }

    // MARK: - Func for Interaction Helpers
    /// Provides UI-related helpers like color mapping and
    /// grid sizing calculations for dynamic layouts.
    func color(from cardColor: CardColor) -> Color {
        switch cardColor {
        case .red: return .red
        case .green: return .green
        case .blue: return .blue
        }
    }

    func gridItemWidthThatFits(
        count: Int,
        size: CGSize,
        atAspectRatio aspectRatio: CGFloat
    ) -> CGFloat {
        let count = CGFloat(count)
        var columnCount = 1.0

        repeat {
            let witdth = (size.width / columnCount)
            let height = witdth / aspectRatio

            let rowCount = (count / columnCount).rounded(.up)
            if rowCount * height < size.height {
                return (size.width / columnCount).rounded(.down)
            }
            columnCount += 1
        } while columnCount < count
        return min(size.width / count, size.height * aspectRatio).rounded(.down)
    }

}
