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
    
    /// A responsive and adaptive grid displaying the current cards in the game.
    ///
    /// This view adapts its layout based on the number of visible (unmatched) cards:
    /// - For fewer than 30 cards: Uses a `GeometryReader` to dynamically calculate the
    ///   optimal grid item width using `gridItemWidthThatFits`, maintaining a consistent
    ///   aspect ratio and tight, responsive layout.
    /// - For 30 or more cards: Switches to a `ScrollView` with fixed item sizing,
    ///   allowing vertical scrolling and preserving performance and clarity.
    ///
    /// Additional behaviors:
    /// - Matched cards are filtered out (not rendered).
    /// - Each card is tappable and connected to game logic through the ViewModel.
    /// - The layout uses `LazyVGrid` with adaptive columns in both modes.
    ///
    var cards: some View {
        Group{
            if viewModel.shapes.prefix(viewModel.cardsToShow).filter({ !$0.isMatched }).count < 30 {
                GeometryReader { geometry in
                    let gridItemSize = viewModel.gridItemWidthThatFits(
                        count: viewModel.shapes.prefix(viewModel.cardsToShow).filter { !$0.isMatched }.count,
                        size: geometry.size,
                        atAspectRatio: 1/3
                    )
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: 8)],
                        spacing: 8
                    ) {
                        ForEach(viewModel.shapes.prefix(viewModel.cardsToShow).filter { !$0.isMatched }) { shape in
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
            } else {
                ScrollView {
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 80), spacing: 8)], spacing: 8
                    ) {
                        ForEach(viewModel.shapes.prefix(viewModel.cardsToShow).filter { !$0.isMatched }) { shape in
                            ShapeItemView(shape: shape, viewModel: viewModel)
                                .frame(width: 50, height: 50 / (2/3))
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                                .onTapGesture {
                                    viewModel.choose(shape)
                                }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SetGameView(viewModel: SetGameViewModel())
}
