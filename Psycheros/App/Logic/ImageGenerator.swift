import Combine
import SwiftUI

protocol ImageGenerating {
    func generate(from: ImageQuery) async throws -> URL
}

enum ImageGeneratingError: Error {
    case incompleteQuery
}

final class ImageGenerator: ImageGenerating {
    private let imageService: ImageServicing
    
    init(imageService: ImageServicing = ImageService()) {
        self.imageService = imageService
    }
    
    func generate(from query: ImageQuery) async throws -> URL {
        guard query.isNotEmpty else {
            throw ImageGeneratingError.incompleteQuery
        }
        
        return try await generateImage(from: query)
    }
    
    private func generateImage(from query: ImageQuery) async throws -> URL {
        let prompt = try PromptGenerator.writePrompt(with: query)
        let model = try ImageRequestModel(prompt: prompt, size: query.size)
        let imageUrl = try await imageService.fetchImage(model: model)
        
        return imageUrl
    }
}
