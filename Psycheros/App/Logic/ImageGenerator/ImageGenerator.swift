import Combine
import SwiftUI

struct AIImage {
    
}

protocol ImageGenerating {
    func generate(from: ImagePrompt) async throws
}

enum ImageGeneratingError: Error {
    case incompletePrompt
}

final class ImageGenerator: ImageGenerating {
    func generate(from prompt: ImagePrompt) async throws {
        try assertNotEmpty(prompt)
    }
    
    private func assertNotEmpty(_ prompt: ImagePrompt) throws {
        guard prompt.color.isEmpty == false,
              prompt.feelings.isEmpty == false else {
            throw ImageGeneratingError.incompletePrompt
        }
    }
    
    private func generateImage(from prompt: ImagePrompt) async -> Image {
        let dummyImage = Image("")
        return dummyImage
    }
}
