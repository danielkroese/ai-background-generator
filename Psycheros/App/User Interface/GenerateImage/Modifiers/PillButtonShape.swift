import SwiftUI

struct PillButtonShape: Shape {
    enum Part: CaseIterable {
        case leading,
             center,
             trailing
    }
    
    let part: Part
    let innerCornerRadius: Double
    let outerCornerRadius: Double
    
    func path(in rect: CGRect) -> Path {
        shape.path(in: rect)
    }
    
    private var shape: UnevenRoundedRectangle {
        UnevenRoundedRectangle(cornerRadii: cornerRadii)
    }
    
    private var cornerRadii: RectangleCornerRadii {
        switch part {
        case .leading:
                .init(
                    topLeading: outerCornerRadius,
                    bottomLeading: outerCornerRadius,
                    bottomTrailing: innerCornerRadius,
                    topTrailing: innerCornerRadius
                )
        case .center:
                .init(
                    topLeading: innerCornerRadius,
                    bottomLeading: innerCornerRadius,
                    bottomTrailing: innerCornerRadius,
                    topTrailing: innerCornerRadius
                )
        case .trailing:
                .init(
                    topLeading: innerCornerRadius,
                    bottomLeading: innerCornerRadius,
                    bottomTrailing: outerCornerRadius,
                    topTrailing: outerCornerRadius
                )
        }
    }
}

#Preview {
    HStack(spacing: 8) {
        ForEach(PillButtonShape.Part.allCases, id: \.hashValue) { part in
            Button(action: { return }) {
                Text("Button")
            }
            .buttonStyle(ShapeButtonStyle(shape: PillButtonShape(part: part, innerCornerRadius: 8, outerCornerRadius: 32)))
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.accentColor)
    .ignoresSafeArea()
}
