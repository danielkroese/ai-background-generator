import SwiftUI

struct GenerateImageView: View {
    @State private var errorText: String = ""
    @State private var uiImage: UIImage = UIImage()
    
    var body: some View {
        ZStack {
            Button {
                generateImage()
            } label: {
                Image(systemName: "wand.and.stars")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .padding()
                    .foregroundStyle(.white)
                    .background(Color.accentColor.opacity(0.8))
                    .clipShape(Circle())
            }
            .background(Color.accentColor.opacity(0.5))
            .clipShape(Circle())
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .padding(32)
            
            Text(errorText)
                .foregroundStyle(Color.accentColor)
                .font(.headline)
                .padding(32)
            
            Image(uiImage: uiImage)
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.accentColor.opacity(0.3))
    }
    
    private func generateImage() {
        Task {
            let generator = ImageGenerator()
            do {
                let imageUrl = try await generator.generate(from: ImageQuery(color: "yellow", themes: [.nature, .island], size: .size896x1152))
                
                uiImage = UIImage(data: try Data(contentsOf: imageUrl)) ?? UIImage()
            } catch {
                errorText = error.localizedDescription
            }
        }
    }
}

#Preview {
    GenerateImageView()
}
