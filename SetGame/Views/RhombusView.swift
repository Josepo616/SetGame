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
/// ```

struct RhombusView: View {
    var filled: Bool = false
    var color: Color
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            Path { path in
                path.move(to: CGPoint(x: width / 2, y: 0))
                path.addLine(to: CGPoint(x: width, y: height / 2))
                path.addLine(to: CGPoint(x: width / 2, y: height))
                path.addLine(to: CGPoint(x: 0, y: height / 2))
                path.closeSubpath()
            }
            .fill(filled ? color : Color.clear)
            .overlay(
                Path { path in
                    path.move(to: CGPoint(x: width / 2, y: 0))
                    path.addLine(to: CGPoint(x: width, y: height / 2))
                    path.addLine(to: CGPoint(x: width / 2, y: height))
                    path.addLine(to: CGPoint(x: 0, y: height / 2))
                    path.closeSubpath()
                }
                .stroke(color, lineWidth: filled ? 0 : 2)
            )
        }
    }
}
