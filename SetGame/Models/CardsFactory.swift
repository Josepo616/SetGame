//
//  CardsFactory.swift
//  SetGame
//
//  Created by JoseAlvarez on 8/7/25.
//

import Foundation

struct CardsFactory {
    static func createDeck() -> [Card] {
        var deck: [Card] = []
        for type in CardType.allCases {
            for color in CardColor.allCases {
                for shading in CardShading.allCases {
                    for count in 1...3 {
                        deck.append(
                            Card(
                                type: type,
                                color: color,
                                shading: shading,
                                count: count
                            )
                        )
                    }
                }
            }
        }
        return deck.shuffled()
    }
}
