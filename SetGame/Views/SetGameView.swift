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
 
struct SetGameView: View {
    @ObservedObject var viewModel: SetGameViewModel
    var body: some View {
        VStack{
            VStack{
                cards
                    .animation(.smooth(duration: 0.5), value: viewModel.shapes)
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
    
    /// A responsive grid that adapts the number and size of cards to fit the available space
    ///
    /// Uses `gridItemWidthThatFits` to compute optimal width per item based on current card count and aspect ratio
    /// Filters out matched cards to prevent them from rendering
    var cards: some View {
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
                            print(viewModel.shapes.count)
                        }
                }
            }
            .padding(8)
        }
    }
}

#Preview {
    SetGameView(viewModel: SetGameViewModel())
}
