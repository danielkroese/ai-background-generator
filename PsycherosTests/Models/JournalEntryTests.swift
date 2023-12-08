import XCTest

final class JournalEntryTests: XCTestCase {
    func test_init_setsExpected() {
        let expectedDate = Date()
        let expectedImage = "image"
        let expectedColor = "yellow"
        let expectedThemes: [Theme] = [.cyberpunk, .space]
        let expectedMotivationalTexts = ["text", "another text"]
        
        let sut = BackgroundEntry(timestamp: expectedDate,
                                 image: expectedImage,
                                 color: expectedColor,
                                 themes: expectedThemes,
                                 motivationalTexts: expectedMotivationalTexts)
        
        XCTAssertEqual(sut.timestamp, expectedDate)
        XCTAssertEqual(sut.image, expectedImage)
        XCTAssertEqual(sut.color, expectedColor)
        XCTAssertEqual(sut.themes, expectedThemes)
        XCTAssertEqual(sut.motivationalTexts, expectedMotivationalTexts)
    }
}
