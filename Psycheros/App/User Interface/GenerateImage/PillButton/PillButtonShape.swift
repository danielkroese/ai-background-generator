import SwiftUI

struct PillButtonShape: Shape {
    let rounded: PillButtonPart
    let innerCornerRadius: Double
    let outerCornerRadius: Double
    
    func path(in rect: CGRect) -> Path {
        shape.path(in: rect)
    }
    
    private var shape: UnevenRoundedRectangle {
        UnevenRoundedRectangle(cornerRadii: cornerRadii)
    }
    
    private var cornerRadii: RectangleCornerRadii {
        switch rounded {
        case .leading:
            RectangleCornerRadii(
                topLeading: outerCornerRadius,
                bottomLeading: outerCornerRadius,
                bottomTrailing: innerCornerRadius,
                topTrailing: innerCornerRadius
            )
        case .center:
            RectangleCornerRadii(
                topLeading: innerCornerRadius,
                bottomLeading: innerCornerRadius,
                bottomTrailing: innerCornerRadius,
                topTrailing: innerCornerRadius
            )
        case .trailing:
            RectangleCornerRadii(
                topLeading: innerCornerRadius,
                bottomLeading: innerCornerRadius,
                bottomTrailing: outerCornerRadius,
                topTrailing: outerCornerRadius
            )
        case .all:
            RectangleCornerRadii(
                topLeading: outerCornerRadius,
                bottomLeading: outerCornerRadius,
                bottomTrailing: outerCornerRadius,
                topTrailing: outerCornerRadius
            )
        case .none:
            RectangleCornerRadii(
                topLeading: innerCornerRadius,
                bottomLeading: innerCornerRadius,
                bottomTrailing: innerCornerRadius,
                topTrailing: innerCornerRadius
            )
        }
    }
}

#Preview {
    HStack(spacing: 8) {
        ForEach(PillButtonPart.allCases, id: \.hashValue) { part in
            Button(action: { return }) {
                Text("Part")
            }
            .buttonStyle(ShapeButtonStyle(shape: PillButtonShape(rounded: part, innerCornerRadius: 8, outerCornerRadius: 32)))
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.accentColor)
    .ignoresSafeArea()
}
