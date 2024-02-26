import SwiftUI

struct LoadingScreen: ViewModifier {
    let isActive: Bool
    
    let value: Double = 0.5
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isActive {
                Overlay(value: value)
                    .zIndex(1)
            }
            
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.5), value: isActive)
    }
    
    private struct Overlay: View {
        let value: Double
        
        var body: some View {
            Rectangle()
                .fill(Material.thin)
                .ignoresSafeArea()
            
            ProgressView(value: value) {
                Text("Generating...")
            }
            .progressViewStyle(.circular)
        }
    }
}

extension View {
    func loadingScreen(isActive: Bool) -> some View {
        modifier(LoadingScreen(isActive: isActive))
    }
}

#Preview {
    Text("Hello")
        .font(.system(size: 160))
        .loadingScreen(isActive: true)
}
