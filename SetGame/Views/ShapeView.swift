//
//  ShapeView.swift
//  SetGame
//
//  Created by JoseAlvarez on 8/1/25.
//

import SwiftUI

struct ShapeItemView: View {
    var shape: Card
    @ObservedObject var viewModel: SetGameViewModel 

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(
                    shape.isSelected ? Color.yellow : Color.black,
                    lineWidth: 3
                )
                .background(
                    RoundedRectangle(cornerRadius: 15).fill(!shape.isFlipped ? Color.white : Color.red)
                )
                .shadow(radius: 5)
            if !shape.isFlipped {
                VStack {
                    ForEach(0..<shape.count, id: \.self) { _ in
                        GeometryReader { geo in
                            let cardWidth = geo.size.width
                            let cardHeight = geo.size.height * CGFloat(shape.count)
                            let shapeWidth = cardWidth * 0.6
                            let shapeHeight = cardHeight * 0.5
                            shapeView(for: shape.type, shading: shape.shading)
                                .frame(width: shapeWidth, height: shapeHeight)
                                .position(
                                    x: geo.size.width / 2,
                                    y: geo.size.height / 2
                                )
                        }
                        .aspectRatio(1, contentMode: .fit)
                        .padding(.vertical, 4)
                    }
                }
                .padding(8)
            }
        }
    }
}



// MARK: cases for item view
extension ShapeItemView {
    @ViewBuilder
    private func shapeView(for type: CardType, shading: CardShading)
        -> some View {
        let rectangleConstant = RoundedRectangle(cornerRadius: 10)
            .frame(width: 35, height: 8)
        switch shading {
        case .filled:
            switch type {
            case .rhombus:
                RhombusShape()
                    .foregroundColor(viewModel.color(from: shape.color))
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
                RhombusShape()
                    .stroke(viewModel.color(from: shape.color))
            case .rectangle:
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(
                        viewModel.color(from: shape.color),
                        lineWidth: 2
                    )
                    .frame(width: 35, height: 8)
            case .square:
                Rectangle()
                    .strokeBorder(
                        viewModel.color(from: shape.color),
                        lineWidth: 2
                    )
                    .frame(width: 15, height: 15)
            }
        case .striped:
            switch type {
            case .rhombus:
                RhombusShape()
                    .stroke(viewModel.color(from: shape.color))
                    .overlay(
                        RhombusShape()
                            .fill(
                                viewModel.color(from: shape.color).opacity(0.3)
                            )
                    )

            case .rectangle:
                rectangleConstant
                    .foregroundColor(
                        viewModel.color(from: shape.color).opacity(0.3)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(
                                viewModel.color(from: shape.color),
                                lineWidth: 2
                            )
                    )
            case .square:
                Rectangle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(
                        viewModel.color(from: shape.color).opacity(0.3)
                    )
                    .overlay(
                        Rectangle()
                            .strokeBorder(
                                viewModel.color(from: shape.color),
                                lineWidth: 2
                            )
                    )
            }
        }
    }
}
