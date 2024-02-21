import SwiftUI

struct LoadingScreen: ViewModifier {
    let isActive: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isActive {
                Rectangle().fill(Material.thin)
                    .ignoresSafeArea()
                    .zIndex(1)
            }
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.5), value: isActive)
    }
}

extension View {
    func loadingScreen(isActive: Bool) -> some View {
        modifier(LoadingScreen(isActive: isActive))
    }
}
