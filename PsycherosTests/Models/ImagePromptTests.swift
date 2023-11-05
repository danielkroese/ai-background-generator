import XCTest

final class ImagePromptTests: XCTestCase {
    func test_init() {
        let expectedColor = "green"
        let expectedFeelings: [Feeling] = [.anxious, .sad]
        
        let sut = ImagePrompt(color: expectedColor,
                              feelings: expectedFeelings)
        
        XCTAssertEqual(sut.color, expectedColor)
        XCTAssertEqual(sut.feelings, expectedFeelings)
    }
}

