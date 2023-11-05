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
        try assertNotEmpty(prompt)
        
        return await generateImage(from: prompt)
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
