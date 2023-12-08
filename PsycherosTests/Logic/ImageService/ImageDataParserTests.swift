import XCTest

final class ImageDataParserTests: XCTestCase {
    func test_parseData_returnsFileUrl() {
        let sut = ImageDataParser()
        
        let dummyData = Data(count: .zero)
        let url = sut.parse(dummyData)
        
        XCTAssertTrue(url.isFileURL)
    }
}
