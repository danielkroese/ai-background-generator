import SwiftUI
import SwiftData

struct GenerateImageView: View {
    
    @State private var text: String = ""
    @State private var uiImage: UIImage = UIImage()
    
    var body: some View {
        VStack {
            Button {
                generateImage()
            } label: {
                Text("Coming soon")
            }
            
            Text(text)
            
            Image(uiImage: uiImage)
        }
    }
    
    private func generateImage() {
        Task {
            let generator = ImageGenerator()
            do {
                let imageUrl = try await generator.generate(from: ImageQuery(color: "yellow", themes: [.nature, .island], size: .size896x1152))
                
                uiImage = UIImage(data: try Data(contentsOf: imageUrl)) ?? UIImage()
            } catch {
                text = error.localizedDescription
            }
        }
    }
}

#Preview {
    GenerateImageView()
}
