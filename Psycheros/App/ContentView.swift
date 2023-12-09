import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State private var text: String = ""
    
    var body: some View {
        VStack {
            Button {
                generateImage()
            } label: {
                Text("Coming soon")
            }
            
            Text(text)
        }
    }
    
    private func generateImage() {
        Task {
            let generator = ImageGenerator()
            do {
                let image = try await generator.generate(from: ImageQuery(color: "blue", themes: [.cyberpunk], size: .size896x1152))
                
                text = image.absoluteString
            } catch {
                text = error.localizedDescription
            }
        }
    }
}

#Preview {
    ContentView()
}
