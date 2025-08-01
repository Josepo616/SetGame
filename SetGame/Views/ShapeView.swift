//
//  ShapeView.swift
//  SetGame
//
//  Created by JoseAlvarez on 8/1/25.
//

import SwiftUI

// MARK: - Individual Shape Card View
/// A visual representation of a single `Shape` card in the Set game
///
/// `ShapeItemView` displays a card with the appropriate number of symbols (1 to 3)
/// using its visual attributes:
/// - `type`: Determines the base shape (e.g., rhombus, oval)
/// - `color`: The base color applied
/// - `shading`: Whether the shape is filled, empty, or striped
///
/// ### UI Behaviors:
/// - Highlights the card border in yellow when selected
/// - Hides the card (opacity = 0) when it's matched
/// - Draws multiple vertically stacked symbols based on the `count` value
///
/// ### Layout Details:
/// - Each symbol is wrapped in a `GeometryReader` to dynamically calculate size based
///   on the overall card dimensions and the number of symbols.
/// - Symbols are centered within their geometry and scaled proportionally to maintain consistent spacing
/// - Padding between symbols is applied via `.padding(.vertical, 4)`.
///
/// This view delegates color decoding to the ViewModel and supports
/// custom rendering logic per shape and shading type
///
struct ShapeItemView: View {
    var shape: Shape
    var viewModel: SetGameViewModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(
                    shape.isSelected ? Color.yellow : Color.black,
                    lineWidth: 3
                )
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
                .shadow(radius: 5)
            VStack {
                ForEach(0..<shape.count, id: \.self) { _ in
                    GeometryReader { geo in
                        let cardWidth = geo.size.width
                        let cardHeight = geo.size.height * CGFloat(shape.count)
                        let shapeWidth = cardWidth * 0.6
                        let shapeHeight = cardHeight * 0.50

                        shapeView(for: shape.type, shading: shape.shading)
                            .frame(width: shapeWidth, height: shapeHeight)
                            .position(x: geo.size.width / 2, y: geo.size.height / 2)
                    }
                    .aspectRatio(1, contentMode: .fit)
                    .padding(.vertical, 4)
                }
            }
            .padding(8)
        }
    }

    /// Returns a view representing a single visual unit of a card's symbol
    /// based on its `type` and `shading`
    ///
    /// Handles the following rendering logic:
    /// - **Filled**: Solid color fill
    /// - **Empty**: Transparent fill with stroke border
    /// - **Striped**: Semi-transparent fill overlaid with stroke border
    ///
    /// The type controls the base shape:
    /// - `rhombus`: Uses `RhombusView`
    /// - `rectangle`: Uses `RoundedRectangle`
    /// - `square`: Uses `Rectangle`
    /// 
    @ViewBuilder
    private func shapeView(for type: ShapeType, shading: ShapeShading) -> some View {
        let rectangleConstant = RoundedRectangle(cornerRadius: 10)
            .frame(width: 35, height: 8)
        switch shading {
        case .filled:
            switch type {
            case .rhombus:
                RhombusView(filled: true, color: viewModel.color(from: shape.color))
            case .rectangle:
                rectangleConstant
                    .foregroundColor(viewModel.color(from: shape.color))
            case .square:
                Rectangle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(viewModel.color(from: shape.color))
            }
        case .empty:
            switch type {
            case .rhombus:
                RhombusView(filled: false, color: viewModel.color(from: shape.color))
            case .rectangle:
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(viewModel.color(from: shape.color), lineWidth: 2)
                    .frame(width: 35, height: 8)
            case .square:
                Rectangle()
                    .strokeBorder(viewModel.color(from: shape.color), lineWidth: 2)
                    .frame(width: 15, height: 15)
            }
        case .striped:
            switch type {
            case .rhombus:
                RhombusView(color: viewModel.color(from: shape.color))
                    .overlay(
                        RhombusView(filled: true, color: viewModel.color(from: shape.color).opacity(0.3))
                    )
            case .rectangle:
                rectangleConstant
                    .foregroundColor(viewModel.color(from: shape.color).opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(viewModel.color(from: shape.color), lineWidth: 2)
                    )
            case .square:
                Rectangle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(viewModel.color(from: shape.color).opacity(0.3))
                    .overlay(
                        Rectangle()
                            .strokeBorder(viewModel.color(from: shape.color), lineWidth: 2))
            }
        }
    }
}
