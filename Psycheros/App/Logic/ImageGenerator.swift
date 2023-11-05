import Combine
import SwiftUI // ??

protocol ImageGenerating {
    func generate(from: ImagePrompt) async throws -> Image
}

enum ImageGeneratingError: Error {
    case incompletePrompt
}

final class ImageGenerator: ImageGenerating {
    func generate(from prompt: ImagePrompt) async throws -> Image {
        guard prompt.isEmpty == false else {
            throw ImageGeneratingError.incompletePrompt
        }
        
        return await generateImage(from: prompt)
    }
    
    private func generateImage(from prompt: ImagePrompt) async -> Image {
        let dummyImage = Image("")
        return dummyImage
    }
}
