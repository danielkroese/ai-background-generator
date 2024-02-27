import SwiftUI

struct LoadingScreen: ViewModifier {
    let isActive: Bool
    
    @State private var value: Double = 0.0
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isActive {
                Overlay(value: value)
                    .zIndex(1)
                    .onAppear {
                        value = 0.9
                    }
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
            .progressViewStyle(DonutProgressViewStyle())
            .padding(128)
        }
    }
    
    private struct DonutProgressViewStyle: ProgressViewStyle {
        var strokeColor: Color = .accentColor
        var strokeWidth: CGFloat = 10.0
        
        func makeBody(configuration: Configuration) -> some View {
            let progress = configuration.fractionCompleted ?? 0
            return ZStack {
                Circle()
                    .stroke(lineWidth: strokeWidth)
                    .opacity(0.3)
                    .foregroundColor(strokeColor)
                
                Circle()
                    .trim(from: 0, to: CGFloat(progress))
                    .stroke(style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                    .foregroundColor(strokeColor)
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.easeInOut(duration: 8.0), value: progress)
            }
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
