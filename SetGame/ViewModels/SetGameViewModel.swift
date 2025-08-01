//
//  SetViewModel.swift
//  SetGame
//
//  Created by JoseAlvarez on 7/28/25.
//

import SwiftUI
// MARK: - Set Game ViewModel
/// Acts as the intermediary between the `SetGameModel` and the View layer in an MVVM architecture
///
/// `SetGameViewModel` exposes the list of shapes and UI-specific state (e.g., number of visible cards)
/// and handles user interactions like selecting cards or starting a new game
///
/// Key responsibilities:
/// - Synchronizes View updates manually via `objectWillChange` after selection
/// - Manages how many cards are visible (`cardsToShow`) and controls the logic for adding more
/// - Bridges model-level logic (`SetGameModel`) with View concerns, including color translation and match feedback
///
/// Important details:
/// - Uses an internal flag (`ChooseAndMakeSet`) to track if a valid set was just made, avoiding extra logic/state for that in the View
/// - Supports user feedback via `showSetMaked()`, giving string status on the current selection
///
class SetGameViewModel: ObservableObject {
    @Published var cardsToShow: Int = 12
    private var ChooseAndMakeSet: Bool? = nil
    private var setGameModel = SetGameModel()
    static var themes: [ShapeType] = [.rhombus, .rectangle, .square]
    var shapes: [Shape] {
        setGameModel.shapes
    }
    
    func choose(_ shape: Shape) {
        ChooseAndMakeSet = setGameModel.choose(shape)
        objectWillChange.send()
        if ChooseAndMakeSet == true {
            addMoreCards()
        }
    }
    
    /// Returns a status message based on the current selection state
    ///
    /// - Returns: `"Set is removed"` if a valid set was found, `"Not a set"` if 3 are selected but invalid, or an empty string otherwise
    func showSetMaked() -> String {
        switch ChooseAndMakeSet {
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

    func startNewGame() {
        setGameModel = SetGameModel()
        cardsToShow = 12
    }
    
    func addMoreCards(_ count: Int = 3) {
        cardsToShow = min(cardsToShow + count, shapes.count)
    }
    
    func color(from shapeColor: ShapeColor) -> Color {
        switch shapeColor {
        case .red: return .red
        case .green: return .green
        case .blue: return .blue
        }
    }
    
    // MARK: View - Automatic size scaling
    /// Calculates the optimal width for a grid item to fit a given number of items
    /// within a container of a certain size, preserving a specified aspect ratio
    ///
    /// The method tries increasing numbers of columns until it finds a layout where
    /// all items can fit vertically within the available height
    ///
    /// - Parameters:
    ///   - count: The total number of items to layout
    ///   - size: The size of the available container (usually from `GeometryReader`)
    ///   - aspectRatio: The desired width-to-height ratio for each grid item (e.g. 1:3)
    /// - Returns: The maximum item width (rounded down) that fits the grid vertically
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
    }while columnCount < count
        return min(size.width / count, size.height * aspectRatio).rounded(.down)
    }
}
