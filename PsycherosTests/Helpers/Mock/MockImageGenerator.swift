import SwiftUI

final class MockImageGenerator: ImageGenerating {
    var generateImageResponse: UIImage?
    var generateImageError: Error?
    private(set) var didCallGenerateImageCount = 0
    private(set) var passedImageQuery: ImageQuery?
    
    func generate(from query: ImageQuery) async throws -> UIImage {
        didCallGenerateImageCount += 1
        passedImageQuery = query
        
        if let error = generateImageError {
            throw error
        }
        
        return generateImageResponse ?? UIImage(resource: .dummy)
    }
}
