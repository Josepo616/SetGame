//
//  SetModel.swift
//  SetGame
//
//  Created by JoseAlvarez on 7/28/25.
//

import Foundation

// MARK: Class Model Definition
/// The model represents the game logic for the Set card Game
///
/// 'SetGameModel' manages the state of the game, including the deck of shape cards
/// selection logic, and validation for identifying valid sets. It follows the MVVM
/// pattern an d is designed to be observed by SwiftUI
///
class SetGameModel{
    var shapes: [Shape] = []
    
    init() {
        shapes = createDeck()
    }
    
    /// Handles the selection of a card by the user.
    ///
    /// This method updates the selection state of cards and determines whether a valid set
    /// has been completed. It follows this logic:
    ///
    /// - If exactly 3 cards are already selected:
    ///     - If they form a valid set, they are marked as matched and deselected. The tapped card is also toggled.
    ///     - If they do **not** form a valid set, all selected cards are deselected and the tapped card is selected.
    /// - If fewer than 3 cards are selected, the tapped card is simply toggled.
    ///
    /// - Parameter card: The `Shape` card that was tapped.
    /// - Returns:
    ///   - `true` if a valid set was formed and removed.
    ///   - `false` if 3 cards were selected but did **not** form a valid set.
    ///   - `nil` if fewer than 3 cards are currently selected (no set validation was performed).
    ///
    func choose(_ card: Shape) -> Bool? {
        guard let index = shapes.firstIndex(where: { $0.id == card.id }) else { return false }
        let selectedCards = shapes.filter { $0.isSelected }
        
        if selectedCards.count == 3 {
            if self.isValidSet(selectedCards) {
                for selected in selectedCards {
                    if let matchIndex = shapes.firstIndex(where: { $0.id == selected.id }) {
                        shapes[matchIndex].isMatched = true
                        shapes[matchIndex].isSelected = false
                    }
                }
                shapes[index].isSelected.toggle()
                return true

            } else {
                for selected in selectedCards {
                    if let deselectIndex = shapes.firstIndex(where: { $0.id == selected.id }) {
                        shapes[deselectIndex].isSelected = false
                    }
                }
                shapes[index].isSelected.toggle()
                return false
            }
        }
        shapes[index].isSelected.toggle()
        
        return nil
    }

    /// Determines whether the given three cards form a valid Set.
    ///
    /// According to the rules of the Set game, a Set is valid if, for **each individual attribute**
    /// (`type`, `color`, `count`, `shading`), the three cards:
    /// - color: different on each card, symbol: the same on each card (oval), number: the same on each (two), shading: the same on each card (solid)
    /// - All have distinct values
    ///
    /// The combination is invalid if **any** attribute has exactly two matching and one differing value.
    ///
    /// - Parameter cards: An array of exactly three `Shape` instances.
    /// - Returns: `true` if the cards form a valid Set; `false` otherwise.
    ///
    private func isValidSet(_ cards: [Shape]) -> Bool {
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

    /// Creates the full deck of 'Shape' cards
    ///
    /// The deck is composed by iterating over all possible combinations of shape attributes:
    /// - 3 types
    /// - 3 colors
    /// - 3 shadigns
    /// - 3 counts
    ///
    /// Resulting in a total of 81 unique cards
    ///
    /// - Returns: An array of all possible 'Shape' combinations shuffled
    ///
    private func createDeck() -> [Shape] {
        var deck: [Shape] = []
        for type in ShapeType.allCases {
            for color in ShapeColor.allCases {
                for shading in ShapeShading.allCases {
                    for count in 1...3 {
                        deck.append(Shape(type: type, color: color, shading: shading, count: count))
                    }
                }
            }
        }
        return deck.shuffled()
    }
}

// MARK: - Shape Model Definitions

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
enum ShapeType: CaseIterable {
    case rhombus, rectangle, square
}

enum ShapeColor: CaseIterable {
    case red, green, blue
}

enum ShapeShading: CaseIterable {
    case filled, empty, striped
}

struct Shape: Identifiable, Equatable {
    let id = UUID()
    let type: ShapeType
    let color: ShapeColor
    let shading: ShapeShading
    let count: Int
    var isMatched = false
    var isSelected = false
}
