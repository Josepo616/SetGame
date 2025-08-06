//
//  SetViewModel.swift
//  SetGame
//
//  Created by JoseAlvarez on 7/28/25.
//

import SwiftUI

class SetGameViewModel: ObservableObject {
    private var setGameModel = SetGameModel()
    @Published private(set) var validSet = false
    @Published private(set) var cards: [Card]
    @Published private(set) var cardsRemaining: [Card]
    @Published private(set) var cardsMatched: [Card]

    public var response = ""

    init(setGameModel: SetGameModel = SetGameModel()) {
        self.setGameModel = setGameModel
        self.cards = setGameModel.cardsOnScreen
        self.cardsRemaining = setGameModel.cards
        self.cardsMatched = setGameModel.cardsMatched
    }

    func choose(_ card: Card) {
        setGameModel.chooseAndMakeSet = setGameModel.choose(card)
        
        if setGameModel.chooseAndMakeSet == true {
            self.cards = setGameModel.cardsOnScreen
            let matchedCards = self.cards.filter { $0.isMatched }
            
            if !matchedCards.isEmpty {
                self.validSet = true
            } else {
                self.validSet = false
            }
            
            self.cards = setGameModel.cardsOnScreen
        }
        
        response = setGameModel.showSetMaked()
        self.cards = setGameModel.cardsOnScreen
    }
    
    // Función separada para la inserción de matchedCards
    func insertMatchedCards(_ matchedCard: [Card]) {
        if self.validSet {
            withAnimation(.easeInOut(duration: 10)) {
                addMatchedCards(matchedCard)
            }
        }
    }

    // Función separada para la actualización de cardsMatched
    func updateCardsMatched() {
        self.cardsMatched = setGameModel.cardsMatched
    }


    func startNewGame() {
        setGameModel = SetGameModel()
        setGameModel.addMoreCards(12)
        self.cardsMatched.removeAll()
        self.cardsRemaining = setGameModel.cards
        self.cards = setGameModel.cardsOnScreen
        loadCards()
    }

    func addMoreCards(_ count: Int) {
        setGameModel.addMoreCards(count)
        self.cards = setGameModel.cardsOnScreen
        self.cardsRemaining = setGameModel.cards
    }

    func addMatchedCards(_ matched: [Card]) {
        setGameModel.addMatchedCards(matched)
        self.cards = setGameModel.cardsOnScreen
        self.cardsMatched = setGameModel.cards
    }

    func flipCardsOnScreen() {
        for index in cards.indices {
            cards[index].isFlipped = false
        }
        if self.cardsMatched.count > 0 {
            for index in cardsMatched.indices {
                cardsMatched[index].isFlipped = false
            }
        }
    }

    func loadCards() {
        flipCardsOnScreen()
    }

}

extension SetGameViewModel {
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
