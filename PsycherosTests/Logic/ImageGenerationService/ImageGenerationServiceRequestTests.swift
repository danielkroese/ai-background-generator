import XCTest

final class ImageGenerationServiceRequestTests: XCTestCase {
    private typealias Error = ImageGenerationServiceRequestingError
    
    func test_init_withEndpoint_setsRequestUrl() {
        assertNoThrow {
            let sut = try createSut()
            
            XCTAssertEqual(dummyUrl, sut.request.url)
        }
    }
    
    func test_init_withInvalidEndpoint_throws() {
        assertThrows(expected: Error.invalidEndpoint) {
            let invalidUrl = URL(string: "")
            
            _ = try ImageGenerationServiceRequest(endpoint: invalidUrl, apiKey: "")
        }
    }
    
    func test_init_setsExpectedHeaders() {
        assertNoThrow {
            let sut = try createSut()
            
            XCTAssertEqual(sut.request.value(forHTTPHeaderField: "Accept"), "application/json")
            XCTAssertEqual(sut.request.value(forHTTPHeaderField: "Content-Type"), "application/json")
            XCTAssertEqual(sut.request.value(forHTTPHeaderField: "Authorization"), "Bearer dummy_key")
        }
    }
    
    func test_prompt_setsExpectedBody() {
        assertNoThrow {
            let expectedHttpBody = ImageRequestModel(
                prompt: "scape, landscape, ecstatic, happy, color blue",
                seed: 123,
                size: CGSize(width: 1024, height: 1024)
            )
            
            let sut = try createSut().prompt(with: expectedHttpBody)
            
            guard let sutHttpBody = sut.request.httpBody else {
                XCTFail("No http body set")
                return
            }
            
            let decodedHttpBody = try JSONDecoder().decode(ImageRequestModel.self, from: sutHttpBody)
            
            XCTAssertEqual(expectedHttpBody, decodedHttpBody)
        }
    }
    
    func test_invalidPrompt_throws() {
        assertThrows(expected: Error.invalidPrompt) {
            _ = try createSut()
                .prompt(with: ImageRequestModel(prompt: ""))
        }
        
        assertThrows(expected: Error.invalidPrompt) {
            _ = try createSut()
                .prompt(with: ImageRequestModel(
                    prompt: "valid prompt",
                    size: CGSize(width: -5, height: -5)
                ))
        }
    }
    
    func test_init_hasExpectedMethod() {
        assertNoThrow {
            let sut = try createSut()
            
            XCTAssertEqual(sut.request.httpMethod, "POST")
        }
    }
}

// MARK: - Test helpers
extension ImageGenerationServiceRequestTests {
    private func createSut() throws -> ImageGenerationServiceRequest {
        return try ImageGenerationServiceRequest(endpoint: dummyUrl, apiKey: dummyApiKey)
    }
    
    private var dummyUrl: URL {
        guard let url = URL(string: "https://danielkroese.nl/") else {
            XCTFail("url unexpectedly nil")
            return .homeDirectory
        }
        
        return url
    }
    
    private var dummyApiKey: String {
        "dummy_key"
    }
}
