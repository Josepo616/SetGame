//
//  ShapeView.swift
//  SetGame
//
//  Created by JoseAlvarez on 8/1/25.
//

import SwiftUI

struct ShapeItemView: View {
    @ObservedObject var viewModel: SetGameViewModel
    var shape: Card

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
