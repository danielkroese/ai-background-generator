import XCTest

final class ImageGenerationServiceResponseTests: XCTestCase {
    private typealias Sut = ImageGenerationServiceResponse
    
    func test_zero() {
        let sut = ImageGenerationServiceResponse(base64: "", finishReason: .success, seed: 0)
    }
    
    func test_invalidFinishReason_setsUnknownReason() {
        let invalidReason = Sut.FinishReason("henk")
        
        let sut = ImageGenerationServiceResponse(base64: "", finishReason: invalidReason, seed: 0)
        
        XCTAssertEqual(sut.finishReason, .unknown)
    }
}

