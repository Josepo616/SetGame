//
//  ShapeModel.swift
//  SetGame
//
//  Created by JoseAlvarez on 8/4/25.
//

import Foundation


/// Represents the core components of a Set Game Card
///
/// A 'Shape' is defined by four main attribures:
/// - 'type': the geometric shape shown on the card
/// - `color`: The color of the shape.
/// - `shading`: The visual style (filled, empty, or striped).
/// - `count`: The number of shapes displayed on the card (1 to 3).

/// Additional boolean flags:
/// - `isMatched`: Whether this card is part of a valid set.
/// - `isSelected`: Whether this card is currently selected by the user.
///
/// Each `Shape` is uniquely identified via a UUID and conforms to `Identifiable` and `Equatable`,
/// making it suitable for use in SwiftUI views and collections.
///
/// The enums `ShapeType`, `ShapeColor`, and `ShapeShading` conform to `CaseIterable`,
/// allowing generation of all possible combinations to form a full deck (81 cards).
///
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
