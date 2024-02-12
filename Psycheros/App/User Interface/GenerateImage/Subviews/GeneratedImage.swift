import SwiftUI

struct GeneratedImage: View {
    let image: UIImage?
    let isLoading: Bool
    
    var body: some View {
        ZStack {
            imageView
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
                .overlay(.thinMaterial)
            
            imageView
                .aspectRatio(contentMode: .fit)
        }
        .animatedHue(isActive: isLoading)
        .frame(
            maxWidth: UIScreen.main.bounds.width,
            maxHeight: UIScreen.main.bounds.height
        )
        .transition(.opacity)
        .animation(.easeInOut, value: image)
    }
    
    @ViewBuilder
    private var imageView: some View {
        if let image {
            Image(uiImage: image)
                .resizable()
        } else {
            Color.accentColor
                .opacity(0.3)
        }
    }
}
