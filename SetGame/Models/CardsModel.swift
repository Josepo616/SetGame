//
//  ShapeModel.swift
//  SetGame
//
//  Created by JoseAlvarez on 8/4/25.
//

import Foundation

enum CardType: CaseIterable {
    case rhombus, rectangle, square
}

enum CardColor: CaseIterable {
    case red, green, blue
}

enum CardShading: CaseIterable {
    case filled, empty, striped
}

struct Card: Identifiable, Equatable {
    let id = UUID()
    let type: CardType
    let color: CardColor
    let shading: CardShading
    let count: Int
    var isMatched = false
    var isSelected = false
    var isFlipped = true
}
