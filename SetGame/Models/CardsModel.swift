//
//  ShapeModel.swift
//  SetGame
//
//  Created by JoseAlvarez on 8/4/25.
//

import Foundation

/// Card-related Enums and Structs - Defines the attributes and states of a card.
/// Includes types, colors, shading, and count for card properties, as well as states like selection and match status.
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
