import XCTest

final class ImageRequestModelTests: XCTestCase {
    func test_isValid_withEmptyPrompt_false() {
        let sut = ImageRequestModel(prompt: "")
        
        XCTAssertFalse(sut.isValid)
    }
}

