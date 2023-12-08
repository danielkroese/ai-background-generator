import SwiftUI
import SwiftData

struct ContentView: View {
    
    var body: some View {
        VStack {
            Button {
                // ...
            } label: {
                Text("Coming soon")
            }
        }
        .task {
            Task {
                let generator = ImageGenerator()
                let image = try await generator.generate(from: ImageQuery(color: "blue", themes: [.cyberpunk]))
                
                print(image.absoluteString)
            }
        }
    }
}

#Preview {
    ContentView()
}
