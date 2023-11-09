import XCTest

final class SpyImageGenerationService: ImageGenerationServicing {
    private(set) var didCallFetchImageCount = 0
    var url: URL = .homeDirectory
    
    func fetchImage(model: ImageRequestModel) async throws -> URL {
        didCallFetchImageCount += 1
        
        return url
    }
}
