import XCTest

final class JournalEntryTests: XCTestCase {
    func test_init_setsExpected() {
        let expectedDate = Date()
        let expectedImage = "image"
        let expectedColor = "yellow"
        let expectedFeelings: [Feeling] = [.happy, .grateful]
        let expectedMotivationalTexts = ["text", "another text"]
        
        let sut = JournalEntry(timestamp: expectedDate,
                                 image: expectedImage,
                                 color: expectedColor,
                                 feelings: expectedFeelings,
                                 motivationalTexts: expectedMotivationalTexts)
        
        XCTAssertEqual(sut.timestamp, expectedDate)
        XCTAssertEqual(sut.image, expectedImage)
        XCTAssertEqual(sut.color, expectedColor)
        XCTAssertEqual(sut.feelings, expectedFeelings)
        XCTAssertEqual(sut.motivationalTexts, expectedMotivationalTexts)
    }
}
