import Foundation

protocol ImageGenerationServicing {
    func requestImage(query: ImageQuery) async throws -> String
}

enum ImageGenerationServicingError: Error {
    
}

final class ImageGenerationService: ImageGenerationServicing {
    func requestImage(query: ImageQuery) async throws -> String {
        ""
    }
}
