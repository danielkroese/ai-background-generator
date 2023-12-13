import SwiftUI

struct CircleButtonModifier: ViewModifier {
    let action: () -> Void
    
    func body(content: Content) -> some View {
        Button(action: action) {
            content
                .padding()
                .foregroundStyle(.white)
                .background(Color.accentColor.opacity(0.8))
                .clipShape(Circle())
        }
        .background(Color.accentColor.opacity(0.5))
        .clipShape(Circle())
    }
}

extension View {
    func circleButtonModifier(action: @escaping () -> Void) -> some View {
        self.modifier(CircleButtonModifier(action: action))
    }
}
