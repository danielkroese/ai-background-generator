import SwiftUI

struct GeneratedImage: View {
    let image: Image?
    let isLoading: Bool
    
    var body: some View {
        VStack {
            if let image {
                image
                    .resizable()
                    .animatedHue(isActive: isLoading)
                    .ignoresSafeArea()
                    .aspectRatio(contentMode: .fill)
            } else {
                Color.accentColor
                    .opacity(0.3)
                    .animatedHue(isActive: isLoading)
                    .ignoresSafeArea()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .transition(.opacity)
        .animation(.easeInOut, value: image)
    }
}
