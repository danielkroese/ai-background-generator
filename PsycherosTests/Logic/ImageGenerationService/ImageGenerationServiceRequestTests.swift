import XCTest

final class ImageGenerationServiceRequestTests: XCTestCase {
    func test_url_prefixedWithHttps() {
        let sut = ImageGenerationServiceRequest()
        
        XCTAssertTrue(sut.url.hasPrefix("https://"))
    }
}

