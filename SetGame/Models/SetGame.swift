//
//  SetModel.swift
//  SetGame
//
//  Created by JoseAlvarez on 7/28/25.
//

import Foundation

final class SetGame: ObservableObject {
    @Published var cardsOnScreen: [Card] = []
    @Published var cardsMatched: [Card] = []
    @Published var cardsRemaining: [Card] = []
    var chooseAndMakeSet: Bool?

    init() {
        cardsRemaining = CardsFactory.createDeck()
    }

    func addMoreCards(_ count: Int) {
        let remainingCards = min(count, cardsRemaining.count)
        if remainingCards > 0 {
            let cardsToAdd = cardsRemaining.prefix(remainingCards)
            cardsOnScreen.append(contentsOf: cardsToAdd)
            cardsRemaining.removeFirst(count)
        }
    }

    func addMatchedCards(_ matched: [Card]) {
        for card in matched {
            if let index = cardsOnScreen.firstIndex(where: { $0.id == card.id })
            {
                cardsMatched.append(cardsOnScreen[index])
                cardsOnScreen.remove(at: index)
            }
        }
    }

    func showSetMaked() -> String {
        switch chooseAndMakeSet {
        case true:
            return "Set was removed"
        case false:
            return "Not a set"
        case nil:
            return ""
        case .some(_):
            return ""
        }
    }

    func choose(_ card: Card) -> Bool? {
        guard let index = cardsOnScreen.firstIndex(where: { $0.id == card.id })
        else {
            return false
        }

        let selectedCards = cardsOnScreen.filter { $0.isSelected }
        if selectedCards.count == 3 {
            if isValidSet(selectedCards) {
                for selected in selectedCards {
                    if let matchIndex = cardsOnScreen.firstIndex(where: {
                        $0.id == selected.id
                    }) {
                        cardsOnScreen[matchIndex].isMatched = true
                        cardsOnScreen[matchIndex].isSelected = false
                        cardsOnScreen[matchIndex].isFlipped = false
                    }
                }
                cardsOnScreen[index].isSelected.toggle()
                return true
            } else {
                for selected in selectedCards {
                    if let deselectIndex = cardsOnScreen.firstIndex(where: {
                        $0.id == selected.id
                    }) {
                        deselectCardWithDelay(index: deselectIndex, delay: 0.1)
                    }
                }
                return false
            }
        }
        cardsOnScreen[index].isSelected.toggle()
        return nil
    }

    func deselectCardWithDelay(index: Int, delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.cardsOnScreen[index].isSelected = false
        }
    }

    func shuffleCardsOnScreen() {
        cardsOnScreen.shuffle()
    }

    //MARK: Private function
    private func isValidSet(_ cards: [Card]) -> Bool {
        guard cards.count == 3 else { return false }

        let allTypes = Set(cards.map { $0.type })
        let allColors = Set(cards.map { $0.color })
        let allCounts = Set(cards.map { $0.count })
        let allShadings = Set(cards.map { $0.shading })

        let validTypes = allTypes.count == 1 || allTypes.count == 3
        let validColors = allColors.count == 1 || allColors.count == 3
        let validCounts = allCounts.count == 1 || allCounts.count == 3
        let validShadings = allShadings.count == 1 || allShadings.count == 3

        return validTypes && validColors && validCounts && validShadings
    }
}
