//
//  RhombusView.swift
//  SetGame
//
//  Created by JoseAlvarez on 8/1/25.
//

import SwiftUI

/// A custom `Shape` that draws a rhombus (diamond shape).
///
/// `RhombusShape` renders a four-point polygon centered within its frame,
/// connecting the top, right, bottom, and left midpoints in sequence.
/// This shape automatically adapts to any given size.
///
/// Usage:
/// ```swift
/// RhombusShape()
///     .stroke(.red)
///     .frame(width: 50, height: 50)
/// ```
///
/// Designed for use in UI components such as cards in a Set game or any
/// layout requiring a geometric diamond shape.
///
struct RhombusShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.width / 2, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height / 2))
        path.addLine(to: CGPoint(x: rect.width / 2, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height / 2))
        path.closeSubpath()

        return path

    }

}
