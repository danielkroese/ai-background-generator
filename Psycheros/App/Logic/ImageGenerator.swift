import Combine
import SwiftUI

protocol ImageGenerating {
    func generate(from: ImageQuery) async throws -> URL
}

enum ImageGeneratingError: Error {
    case incompleteQuery
}

final class ImageGenerator: ImageGenerating {
    private let imageGenerationService: ImageGenerationServicing
    
    init(imageGenerationService: ImageGenerationServicing) {
        self.imageGenerationService = imageGenerationService
    }
    
    func generate(from query: ImageQuery) async throws -> URL {
        guard query.isNotEmpty else {
            throw ImageGeneratingError.incompleteQuery
        }
        
        return try await generateImage(from: query)
    }
    
    private func generateImage(from query: ImageQuery) async throws -> URL {
        let prompt = try PromptGenerator.writePrompt(with: query)
        let model = try ImageRequestModel(prompt: prompt)
        let imageUrl = try await imageGenerationService.fetchImage(model: model)
        
        return imageUrl
    }
}
