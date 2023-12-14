import SwiftUI

struct BlurEffect: UIViewRepresentable {
    var effect: UIBlurEffect.Style = .systemMaterial
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        let view = UIVisualEffectView()
        view.effect = UIBlurEffect(style: effect)
        
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
        uiView.effect = UIBlurEffect(style: effect)
    }
}

struct BlurEffectModifier: ViewModifier {
    let effect: UIBlurEffect.Style
    
    func body(content: Content) -> some View {
        content
            .background(BlurEffect(effect: effect))
    }
}

extension View {
    func blurBackground(effect: UIBlurEffect.Style = .systemMaterial) -> some View {
        self.modifier(BlurEffectModifier(effect: effect))
    }
}

#Preview {
    Text("Hello, world!")
        .padding()
        .blurBackground(effect: .systemMaterial)
}
