import SwiftUI
import SwiftData

@main
struct PsycherosApp: App {
    var body: some Scene {
        WindowGroup {
            GenerateImageView(viewModel: GenerateImageViewModel())
        }
    }
}
