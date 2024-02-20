import SwiftUI

struct LoadingScreen: ViewModifier {
    let isActive: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isActive {
                Rectangle().fill(Material.thin)
                    .ignoresSafeArea()
            }
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: 1.0), value: isActive)
    }
}

extension View {
    func loadingScreen(isActive: Bool) -> some View {
        modifier(LoadingScreen(isActive: isActive))
    }
}
