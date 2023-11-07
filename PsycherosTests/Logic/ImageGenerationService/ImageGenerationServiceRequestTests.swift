import XCTest

final class ImageGenerationServiceRequestTests: XCTestCase {
    func test_init_withEndpoint_setsRequestUrl() {
        guard let dummyUrl = URL(string: "https://danielkroese.nl/") else {
            XCTFail("expected url unexpectedly nil")
            return
        }
        
        let sut = ImageGenerationServiceRequest(endpoint: dummyUrl)
        
        XCTAssertEqual(dummyUrl, sut.request.url)
    }
}

