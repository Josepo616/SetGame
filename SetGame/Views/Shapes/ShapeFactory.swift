//
//  ShapeFactory.swift
//  SetGame
//
//  Created by JoseAlvarez on 8/7/25.
//

import SwiftUI

extension ShapeItemView {
    @ViewBuilder
    public func shapeView(for type: CardType, shading: CardShading)
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
