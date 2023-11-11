import XCTest

final class ImageGenerationServiceResponseTests: XCTestCase {
    func test_zero() {
        let sut = ImageGenerationServiceResponse(base64: "", finishReason: .success, seed: 0)
    }
}

