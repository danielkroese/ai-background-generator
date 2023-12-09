import SwiftUI
import SwiftData

struct ContentView: View {
    
    var body: some View {
        VStack {
            Button {
                generateImage()
            } label: {
                Text("Coming soon")
            }
        }
    }
    
    private func generateImage() {
        Task {
            let generator = ImageGenerator()
            do {
                let image = try await generator.generate(from: ImageQuery(color: "blue", themes: [.cyberpunk]))
                
                print(image.absoluteString)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ContentView()
}
