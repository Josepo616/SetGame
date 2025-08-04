//
//  ContentView.swift
//  SetGame
//
//  Created by JoseAlvarez on 7/28/25.
//

import SwiftUI

// MARK: - Set Game Main View

/// The main View for the Set game interface
///
/// `SetGameView` renders the current list of cards, handles user interactions (selecting cards, starting a new game
/// adding more cards), and updates dynamically in response to changes in the game state
/// Highlights:
/// - Uses `GeometryReader` and a responsive `LazyVGrid` to size and layout cards adaptively based on available space
/// - Animates card layout changes smoothly
/// - Includes feedback text and control buttons for gameplay actions
///
/// Requires an external `SetGameViewModel` to manage state and logic
/// 
struct SetGameView: View {
    @ObservedObject var viewModel: SetGameViewModel
    var body: some View {
        VStack{
            VStack{
                VStack{
                    cards
                        .animation(.smooth(duration: 0.5), value: viewModel.shapes)
                }
            }
            .imageScale(.large)
            .padding()
            HStack{
                Text("\(viewModel.showSetMaked())")
            }
            HStack{
                Button("Add cards"){
                    viewModel.addMoreCards(3)
                }
                Button("New game"){
                    viewModel.startNewGame()
                }
            }
        }
    }
    
    /// A responsive and adaptive grid displaying the current active (unmatched) cards in the game.
    ///
    /// This view adjusts its layout and scrolling behavior based on the number of cards shown:
    /// - For fewer than 30 cards:
    ///   - Uses a `GeometryReader` to calculate a dynamic grid item width via
    ///     `gridItemWidthThatFits`, maintaining a consistent aspect ratio and maximizing space usage.
    ///   - Scrolling is disabled to allow a compact, responsive grid that fits within available space.
    /// - For 30 or more cards:
    ///   - Applies a fixed item size (80 pts wide) for each grid item to ensure visual consistency.
    ///   - Enables vertical scrolling to accommodate the larger set of cards without cramping the layout.
    ///
    /// Additional features:
    /// - Filters out matched cards to avoid rendering them.
    /// - Cards are rendered in a `LazyVGrid` using adaptive columns, ensuring responsive wrapping.
    /// - Each card is tappable and triggers game logic through the ViewModel's `choose` method.
    /// - The view structure remains unified, avoiding code duplication by leveraging `scrollDisabled(_:)`.
    ///
    var cards: some View {
        GeometryReader { geometry in
            let visibleCards = viewModel.shapes
                .prefix(viewModel.cardsToShow)
                .filter { !$0.isMatched }

            let shouldScroll = visibleCards.count >= 30
            let gridItemSize = shouldScroll
                ? 80.0
                : viewModel.gridItemWidthThatFits(
                    count: visibleCards.count,
                    size: geometry.size,
                    atAspectRatio: 1/3
                )

            ScrollView(.vertical) {
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: 8)],
                    spacing: 8
                ) {
                    ForEach(visibleCards) { shape in
                        ShapeItemView(shape: shape, viewModel: viewModel)
                            .frame(width: gridItemSize, height: gridItemSize / (2/3))
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                            .onTapGesture {
                                viewModel.choose(shape)
                            }
                    }
                }
                .padding(8)
            }
            .scrollDisabled(!shouldScroll)
        }
    }

}

#Preview {
    SetGameView(viewModel: SetGameViewModel())
}
