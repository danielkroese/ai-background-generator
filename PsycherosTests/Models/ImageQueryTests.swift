import XCTest

final class ImageQueryTests: XCTestCase {
    func test_init_setsExpected() {
        let expectedColor = "green"
        let expectedThemes: [Theme] = [.cyberpunk, .island]
        
        let sut = ImageQuery(color: expectedColor,
                             themes: expectedThemes)
        
        XCTAssertEqual(sut.color, expectedColor)
        XCTAssertEqual(sut.themes, expectedThemes)
    }
}

