import Combine
import SwiftUI

protocol ImageGenerating {
    func generate(from: ImageQuery) async throws -> Image
}

enum ImageGeneratingError: Error {
    case incompleteQuery
}

final class ImageGenerator: ImageGenerating {
    private let imageService: ImageServicing
    
    init(imageService: ImageServicing = ImageService()) {
        self.imageService = imageService
    }
    
    func generate(from query: ImageQuery) async throws -> Image {
        guard query.isNotEmpty else {
            throw ImageGeneratingError.incompleteQuery
        }
        
        return try await generateImage(from: query)
    }
    
    private func generateImage(from query: ImageQuery) async throws -> Image {
        let prompt = try PromptGenerator.writePrompt(with: query)
        let model = try ImageRequestModel(prompt: prompt, size: query.size)
        let imageUrl = try await imageService.fetchImage(model: model)
        let image = createImage(from: imageUrl)
        
        return image
    }
    
    private func createImage(from imageUrl: URL) -> Image {
        guard let dataFromUrl = try? Data(contentsOf: imageUrl),
              let uiImage = UIImage(data: dataFromUrl) else {
            return Image(uiImage: UIImage())
        }
        
        return Image(uiImage: uiImage)
    }
}
