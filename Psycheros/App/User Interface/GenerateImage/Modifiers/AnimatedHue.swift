import SwiftUI

struct AnimatedHue: ViewModifier {
    let isActive: Bool
    
    @State private var angle = Angle(degrees: .zero)
    
    func body(content: Content) -> some View {
        content
            .hueRotation(angle)
            .onChange(of: isActive, { _, newValue in
                if newValue {
                    withAnimation(.easeInOut(duration: 4).repeatForever()) {
                        angle = Angle(degrees: 180.0)
                    }
                } else {
                    withAnimation(.smooth) {
                        angle = Angle(degrees: .zero)
                    }
                }
            })
    }
}

extension View {
    func animatedHue(isActive: Bool) -> some View {
        self.modifier(AnimatedHue(isActive: isActive))
    }
}

#Preview {
    Color.clear
        .animatedHue(isActive: true)
        .ignoresSafeArea()
}
