import Foundation

protocol ImageGenerationServicing {
    func fetchImage(model: ImageRequestModel) async throws -> URL
}

enum ImageGenerationServicingError: Error {
    
}

final class ImageGenerationService: ImageGenerationServicing {
    func fetchImage(model: ImageRequestModel) async throws -> URL {
        let request = try ImageGenerationServiceRequest(apiKey: "")
            .requestImage(model)
            .request
        
        return URL.homeDirectory
    }
}
