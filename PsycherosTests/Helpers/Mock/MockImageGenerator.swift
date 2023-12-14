import SwiftUI

final class MockImageGenerator: ImageGenerating {
    var generateImageResponse: Image?
    var generateImageError: Error?
    private(set) var didCallGenerateImageCount = 0
    
    func generate(from: ImageQuery) async throws -> Image {
        didCallGenerateImageCount += 1
        
        if let error = generateImageError {
            throw error
        }
        
        return generateImageResponse ?? dummyImageUrl
    }
    
    private var dummyImageUrl: Image {
        let resource = ImageResource(name: "dummy_image", bundle: Bundle(for: Self.self))
        
        return Image(resource)
    }
}
