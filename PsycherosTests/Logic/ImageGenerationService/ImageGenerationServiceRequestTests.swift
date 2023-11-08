import XCTest

final class ImageGenerationServiceRequestTests: XCTestCase {
    func test_init_withEndpoint_setsRequestUrl() {
        assertThrowsOnlyExpected {
            let sut = try createSut()
            
            XCTAssertEqual(dummyUrl, sut.request.url)
        }
    }
    
    func test_init_withInvalidEndpoint_throws() {
        let expectation = XCTestExpectation(description: "throws invalidEndpoint")
        let invalidUrl = URL(string: "")
        
        assertThrowsOnlyExpected {
            do {
                _ = try ImageGenerationServiceRequest(endpoint: invalidUrl, apiKey: "")
            } catch ImageGenerationServiceRequestingError.invalidEndpoint {
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_init_setsExpectedHeaders() {
        assertThrowsOnlyExpected {
            let sut = try createSut()
            
            XCTAssertEqual(sut.request.value(forHTTPHeaderField: "Accept"), "application/json")
            XCTAssertEqual(sut.request.value(forHTTPHeaderField: "Content-Type"), "application/json")
            XCTAssertEqual(sut.request.value(forHTTPHeaderField: "Authorization"), "Bearer dummy_key")
        }
    }
    
    func test_prompt_setsExpectedBody() {
        assertThrowsOnlyExpected {
            let sut = try createSut()
                .prompt(
                    "scape, landscape, ecstatic, happy, color blue",
                    seed: 123,
                    size: CGSize(width: 1024, height: 1024)
                )
            
            let expectedHttpBody = ImageRequestModel(
                steps: 40,
                width: 1024,
                height: 1024,
                seed: 123,
                cfgScale: 5,
                samples: 1,
                textPrompts: [
                    .init(text: "scape, landscape, ecstatic, happy, color blue", weight: 1),
                    .init(text: "blurry, bad, text", weight: -1)
                ]
            )
            
            guard let sutHttpBody = sut.request.httpBody else {
                XCTFail("No http body set")
                return
            }
            
            let decodedHttpBody = try JSONDecoder().decode(ImageRequestModel.self, from: sutHttpBody)
            
            XCTAssertEqual(expectedHttpBody, decodedHttpBody)
        }
    }
    
    func test_emptyPrompt_throws() {
        let expectation = XCTestExpectation(description: "throws invalidPrompt")
        
        assertThrowsOnlyExpected {
            do {
                _ = try createSut()
                    .prompt(
                        "",
                        seed: 321,
                        size: CGSize(width: 1024, height: 1024)
                    )
            } catch ImageGenerationServiceRequestingError.invalidPrompt {
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_init_hasExpectedMethod() {
        assertThrowsOnlyExpected {
            let sut = try createSut()
            
            XCTAssertEqual(sut.request.httpMethod, "POST")
        }
    }
    
    private func assertThrowsOnlyExpected(
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (() throws -> Void)
    ) {
        do {
            try closure()
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)", file: file, line: line)
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
