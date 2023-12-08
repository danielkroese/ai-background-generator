import XCTest

final class ImageDataParserTests: XCTestCase {
    func test_parseData_returnsFileUrl() {
        let sut = ImageDataParser()
        
        XCTAssertTrue(sut.parseData().isFileURL)
    }
}
