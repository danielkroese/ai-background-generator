import SwiftUI

struct ShapeButtonModifier<S: Shape>: ViewModifier {
    let shape: S
    let action: () -> Void
    
    func body(content: Content) -> some View {
        Button(action: action) {
            content
                .padding(24)
                .foregroundStyle(.foreground.opacity(0.8))
                .clipShape(shape)
        }
        .blurBackground(effect: .systemUltraThinMaterial)
        .clipShape(shape)
        .shadowModifier()
    }
}

extension View {
    func shapeButtonModifier<S: Shape>(
        shape: S = Circle(),
        action: @escaping () -> Void
    ) -> some View {
        self.modifier(ShapeButtonModifier(shape: shape, action: action))
    }
}

#Preview {
    Text("Hello, world!")
        .shapeButtonModifier(shape: RoundedRectangle(cornerRadius: 32)) { }
}
