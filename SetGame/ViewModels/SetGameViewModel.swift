//
//  SetViewModel.swift
//  SetGame
//
//  Created by JoseAlvarez on 7/28/25.
//

import SwiftUI

class SetGameViewModel: ObservableObject {
    private var setGameModel = SetGameModel()
    var activeAnimation: Bool = false
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
            //addMoreCards(3)
            self.cardsMatched = setGameModel.cardsMatched
        }
        response = setGameModel.showSetMaked()
        self.cards = setGameModel.cardsOnScreen
    }
    
    func startNewGame() {
        setGameModel = SetGameModel()
        setGameModel.addMoreCards(12)
        self.cardsMatched.removeAll()
        self.cardsRemaining = setGameModel.cards
        self.cards = setGameModel.cardsOnScreen
        loadCards()
        activeAnimation = false
    }
    
    func addMoreCards(_ count: Int) {
        setGameModel.addMoreCards(count)
        self.cards = setGameModel.cardsOnScreen
        self.cardsRemaining = setGameModel.cards
    }
    
    func flipCardsOnScreen() {
        for index in cards.indices {
            cards[index].isFlipped = false
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
