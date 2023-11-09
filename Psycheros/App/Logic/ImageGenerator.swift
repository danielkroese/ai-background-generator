import Combine
import SwiftUI // TODO: Prevent this import

protocol ImageGenerating {
    func generate(from: ImageQuery) async throws -> Image
}

enum ImageGeneratingError: Error {
    case incompleteQuery
}

final class ImageGenerator: ImageGenerating {
    private let promptGenerator: PromptGenerating
    
    init(promptGenerator: PromptGenerating) {
        self.promptGenerator = promptGenerator
    }
    
    func generate(from prompt: ImageQuery) async throws -> Image {
        guard prompt.isNotEmpty else {
            throw ImageGeneratingError.incompleteQuery
        }
        
        return try await generateImage(from: prompt)
    }
    
    private func generateImage(from query: ImageQuery) async throws -> Image {
        let dummyImage = Image("")
        
        let prompt = try promptGenerator.writePrompt(with: query)
        let model = try ImageRequestModel(prompt: prompt)
        
        
        return dummyImage
    }
}
