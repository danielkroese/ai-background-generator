import Combine
import SwiftUI // ??

protocol ImageGenerating {
    func generate(from: ImagePrompt) async throws -> Image
}

enum ImageGeneratingError: Error {
    case incompletePrompt
}

final class ImageGenerator: ImageGenerating {
    private let promptGenerator: PromptGenerating
    
    init(promptGenerator: PromptGenerating) {
        self.promptGenerator = promptGenerator
    }
    
    func generate(from prompt: ImagePrompt) async throws -> Image {
        guard prompt.isEmpty == false else {
            throw ImageGeneratingError.incompletePrompt
        }
        
        return try await generateImage(from: prompt)
    }
    
    private func generateImage(from prompt: ImagePrompt) async throws -> Image {
        let dummyImage = Image("")
        
        _ = try promptGenerator.writePrompt(with: prompt)
        
        return dummyImage
    }
}
