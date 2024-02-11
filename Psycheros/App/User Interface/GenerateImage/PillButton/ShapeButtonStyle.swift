import SwiftUI

struct ShapeButtonStyle<S: Shape>: ButtonStyle {
    var isLoading = false
    let shape: S
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(16)
            .shimmer(isLoading)
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
