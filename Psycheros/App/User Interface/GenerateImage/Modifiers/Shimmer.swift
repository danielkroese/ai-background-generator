import SwiftUI

struct Shimmer: ViewModifier {
    let isActive: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var isAnimated = false

    func body(content: Content) -> some View {
        content
            .overlay {
                linearGradient
                    .blendMode(blendMode)
                    .allowsHitTesting(false)
            }
            .animation(isActive ? animation : nil, value: isAnimated)
            .onAppear {
                isAnimated = isActive
            }
            .onChange(of: isActive) { oldValue, newValue in
                guard newValue != oldValue else {
                    return
                }
                
                isAnimated = newValue
            }
    }
    
    private var linearGradient: LinearGradient {
        LinearGradient(gradient: gradient, startPoint: startPoint, endPoint: endPoint)
    }
    
    private var blendMode: BlendMode {
        colorScheme == .light ? .darken : .lighten
    }
    
    private let gradient = Gradient(colors: [
        .clear,
        .primary.opacity(0.1),
        .primary.opacity(0.2),
        .primary.opacity(0.1),
        .clear
    ])
    
    private var startPoint: UnitPoint {
        isAnimated ? UnitPoint(x: 1, y: 1) : UnitPoint(x: -1, y: -1)
    }

    private var endPoint: UnitPoint {
        isAnimated ? UnitPoint(x: 2, y: 2) : UnitPoint(x: 0, y: 0)
    }
    
    private let animation = Animation
        .linear(duration: 1)
        .delay(0.5)
        .repeatForever(autoreverses: false)
}

extension View {
    func shimmer(_ isActive: Bool = true) -> some View {
        self.modifier(Shimmer(isActive: isActive))
    }
}
