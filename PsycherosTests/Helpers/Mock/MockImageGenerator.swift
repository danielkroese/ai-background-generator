import SwiftUI

final class MockImageGenerator: ImageGenerating {
    var generateImageResponse: Image?
    var generateImageError: Error?
    
    private var dummyImageUrl: Image {
        let resource = ImageResource(name: "dummy_image", bundle: Bundle(for: Self.self))
        
        return Image(resource)
    }
    
    func generate(from: ImageQuery) async throws -> Image {
        if let error = generateImageError {
            throw error
        }
        
        return generateImageResponse ?? dummyImageUrl
    }
}
