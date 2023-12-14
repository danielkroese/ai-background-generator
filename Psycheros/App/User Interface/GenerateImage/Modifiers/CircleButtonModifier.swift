import SwiftUI

struct CircleButtonModifier: ViewModifier {
    let action: () -> Void
    
    func body(content: Content) -> some View {
        Button(action: action) {
            content
                .padding()
                .foregroundStyle(.white)
                .background(Color.accentColor.opacity(0.2))
                .clipShape(Circle())
        }
        .blurBackground(effect: .systemUltraThinMaterial)
        .clipShape(Circle())
        .shadow(color: .black.opacity(0.6), radius: 10, y: 10)
        .shadow(color: .black.opacity(0.2), radius: 20, y: 20)
    }
}

extension View {
    func circleButtonModifier(action: @escaping () -> Void) -> some View {
        self.modifier(CircleButtonModifier(action: action))
    }
}
