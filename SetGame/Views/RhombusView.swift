//
//  RhombusView.swift
//  SetGame
//
//  Created by JoseAlvarez on 8/1/25.
//

import SwiftUI

/// A custom SwiftUI `View` that renders a rhombus (diamond shape)
/// `RhombusView` draws a four-pointed polygon centered within the available frame
/// using `GeometryReader` to adapt to any size. It supports two modes:
/// - **Filled**: The rhombus is rendered with a solid fill color
/// - **Outlined**: The rhombus is transparent with a colored stroke
/// - Tutorial:
/// ```swift
/// RhombusView(filled: true, color: .red)
///     .frame(width: 50, height: 50)
/// The shape is drawn symmetrically by connecting midpoints of each edge:
/// Top, Right, Bottom, Left → then closing the path
/// Designed for use in card views in a Set game or similar interfaces
///
/// Note:
/// - The rhombus shape is drawn using a closure called `rhombusPoints` which generates
///   the path for the shape. Instead of declaring the points for the shape multiple
///   times, they are now defined in a single closure to reduce redundancy. This results
///   in cleaner and more efficient code.
/// - The closure accepts the width and height of the frame and calculates the four points:
///   Top, Right, Bottom, and Left, and then closes the path.
/// ```


struct RhombusView: View {
    var filled: Bool = false
    var color: Color
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let rhombusPoints: (CGFloat, CGFloat) -> Path = { width, height in
                Path { path in
                    path.move(to: CGPoint(x: width / 2, y: 0))
                    path.addLine(to: CGPoint(x: width, y: height / 2))
                    path.addLine(to: CGPoint(x: width / 2, y: height))
                    path.addLine(to: CGPoint(x: 0, y: height / 2))
                    path.closeSubpath()
                }
            }
            rhombusPoints(width, height)
                .fill(filled ? color : Color.clear)
                .overlay(
                    rhombusPoints(width, height)
                        .stroke(color, lineWidth: filled ? 0 : 2))
        }
    }
}
