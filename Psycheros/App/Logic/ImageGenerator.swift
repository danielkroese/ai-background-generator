import Combine
import SwiftUI

protocol ImageGenerating {
    func generate(from: ImageQuery) async throws -> UIImage
}

enum ImageGeneratingError: String, Error {
    case incompleteQuery,
         inPreviewMode
}

final class ImageGenerator: ImageGenerating {
    private let imageService: ImageServicing
    
    init(imageService: ImageServicing = ImageService()) {
        self.imageService = imageService
    }
    
    func generate(from query: ImageQuery) async throws -> UIImage {
        guard query.isNotEmpty else {
            throw ImageGeneratingError.incompleteQuery
        }
        
        guard isPreview == false else {
            try await Task.sleep(nanoseconds: 3_000_000_000)
            
            throw ImageGeneratingError.inPreviewMode
        }
        
        return try await generateImage(from: query)
    }
    
    private func generateImage(from query: ImageQuery) async throws -> UIImage {
        let prompt = try PromptGenerator.writePrompt(with: query)
        let model = try ImageRequestModel(prompt: prompt, size: query.size)
        let imageUrl = try await imageService.fetchImage(model: model)
        let image = createImage(from: imageUrl)
        
        return image
    }
    
    private func createImage(from imageUrl: URL) -> UIImage {
        guard let dataFromUrl = try? Data(contentsOf: imageUrl),
              let uiImage = UIImage(data: dataFromUrl) else {
            return UIImage()
        }
        
        return uiImage
    }
    
    private var isPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
