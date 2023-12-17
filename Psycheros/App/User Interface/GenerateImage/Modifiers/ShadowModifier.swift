import SwiftUI

struct SchadowModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    
    let opacity: Double
    
    private var isDark: Bool { colorScheme == .dark }
    private var topLeadingColor: Color { isDark ? .black : .white }
    private var bottomTrailingColor: Color { isDark ? .black : .black }
    
    func body(content: Content) -> some View {
        content
            .shadow(
                color: topLeadingColor.opacity(opacity),
                radius: 15, x: -5, y: -5
            )
            .shadow(
                color: bottomTrailingColor.opacity(opacity),
                radius: 10, x: 5, y: 5
            )
    }
}

extension View {
    func shadowModifier(opacity: Double = 0.1) -> some View {
        self.modifier(SchadowModifier(opacity: opacity))
    }
}

#Preview {
    Circle()
        .fill(.background)
        .frame(width: 100, height: 100)
        .shadowModifier()
}
