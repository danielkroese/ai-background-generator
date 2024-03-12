import SwiftUI

struct LoadingScreen: ViewModifier {
    @Binding var isActive: Bool
    
    @State private var isOverlayVisible = false
    @State private var value: Double = .zero
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isOverlayVisible {
                Overlay(value: value)
                    .zIndex(1)
                    .onDisappear {
                        value = .zero
                    }
            }
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.5), value: isOverlayVisible)
        .onChange(of: isActive) { _, newValue in
            if newValue {
                isOverlayVisible = true
                
                withAnimation(.easeInOut(duration: 8)) {
                    value = 0.9
                }
            } else {
                withAnimation(.easeInOut(duration: 0.5)) {
                    value = 1.0
                } completion: {
                    isOverlayVisible = false
                }
            }
        }
    }
    
    private struct Overlay: View {
        let value: Double
        
        var body: some View {
            Rectangle()
                .fill(Material.ultraThin)
                .ignoresSafeArea()
            
            ProgressView(value: value) {
                Text("Generating...")
            }
            .progressViewStyle(DonutProgressViewStyle())
            .padding(128)
        }
    }
    
    private struct DonutProgressViewStyle: ProgressViewStyle {
        var strokeColor: Color = .accentColor
        var strokeWidth: CGFloat = 10.0
        
        func makeBody(configuration: Configuration) -> some View {
            let progress = configuration.fractionCompleted ?? .zero
            
            return ZStack {
                Circle()
                    .stroke(lineWidth: strokeWidth)
                    .opacity(0.3)
                    .foregroundColor(strokeColor)
                
                Circle()
                    .trim(from: .zero, to: CGFloat(progress))
                    .stroke(style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                    .foregroundColor(strokeColor)
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.easeIn(duration: 8.0), value: progress)
            }
        }
    }
}

extension View {
    func loadingScreen(isActive: Binding<Bool>) -> some View {
        modifier(LoadingScreen(isActive: isActive))
    }
}

#Preview {
    Text("Hello")
        .font(.system(size: 160))
        .loadingScreen(isActive: .constant(true))
}
