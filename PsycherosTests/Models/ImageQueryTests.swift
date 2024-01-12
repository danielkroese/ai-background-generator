import XCTest

final class ImageQueryTests: XCTestCase {
    func test_init_setsExpected() {
        let expectedColor = "green"
        let expectedThemes: Set<Theme> = [.cyberpunk, .island]
        
        let sut = ImageQuery(color: expectedColor,
                             themes: expectedThemes, 
                             size: .size1024x1024)
        
        XCTAssertEqual(sut.color, expectedColor)
        XCTAssertEqual(sut.themes, expectedThemes)
    }
}

