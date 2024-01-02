import SwiftUI

struct ShapeButtonStyle<S: Shape>: ButtonStyle {
    let shape: S
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(24)
            .foregroundStyle(.foreground.opacity(0.8))
            .background(.thinMaterial)
            .clipShape(shape)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .shadowModifier(opacity: configuration.isPressed ? .zero : 0.1)
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
    }
}

#Preview {
    Button(action: { return }) {
        Text("Button")
    }
    .buttonStyle(ShapeButtonStyle(shape: Circle()))
}
