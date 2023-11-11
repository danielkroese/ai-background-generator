import XCTest

final class ImageGenerationServiceResponseTests: XCTestCase {
    private typealias Sut = ImageGenerationServiceResponse
    
    func test_invalidFinishReason_setsUnknownReason() {
        let invalidReason = Sut.FinishReason("henk")
        
        let sut = ImageGenerationServiceResponse(base64: "", finishReason: invalidReason, seed: 0)
        
        XCTAssertEqual(sut.finishReason, .unknown)
    }
    
    func test_uppercaseFinishReason_isValid() {
        let finishReason = Sut.FinishReason("SUCCESS")
        
        let sut = ImageGenerationServiceResponse(base64: "", finishReason: finishReason, seed: 0)
        
        XCTAssertEqual(sut.finishReason, .success)
    }
}

