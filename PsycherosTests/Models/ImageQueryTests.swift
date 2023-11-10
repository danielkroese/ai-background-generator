import XCTest

final class ImageQueryTests: XCTestCase {
    func test_init_setsExpected() {
        let expectedColor = "green"
        let expectedFeelings: [Feeling] = [.anxious, .sad]
        
        let sut = ImageQuery(color: expectedColor,
                              feelings: expectedFeelings)
        
        XCTAssertEqual(sut.color, expectedColor)
        XCTAssertEqual(sut.feelings, expectedFeelings)
    }
}

