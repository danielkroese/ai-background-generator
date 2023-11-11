import XCTest

final class ImageGenerationServiceResponseTests: XCTestCase {
    private typealias Error = ImageGenerationServiceResponseError
    
    func test_decodedFromJson_hasExpectedValues() {
        assertNoThrow {
            let expectedFirstResult = ImageGenerationServiceResponse(
                base64: "...very long string...",
                finishReason: .success,
                seed: 1050625087
            )
            
            let expectedSecondResult = ImageGenerationServiceResponse(
                base64: "...very long string...",
                finishReason: .contentFiltered,
                seed: 1229191277
            )
            
            guard let jsonData = """
                [
                   [
                      {
                         "base64":"...very long string...",
                         "finishReason":"SUCCESS",
                         "seed":1050625087
                      },
                      {
                         "base64":"...very long string...",
                         "finishReason":"CONTENT_FILTERED",
                         "seed":1229191277
                      }
                   ]
                ]
            """.data(using: .utf8) else {
                XCTFail("Could not create mock json data.")
                return
            }
            
            guard let decodedResults = try JSONDecoder().decode([[ImageGenerationServiceResponse]].self, from: jsonData).first else {
                XCTFail("Could not decode mock json data.")
                return
            }
            
            XCTAssertTrue(decodedResults.contains { $0 == expectedFirstResult })
            XCTAssertTrue(decodedResults.contains { $0 == expectedSecondResult })
        }
    }
    
    func test_decode_withInvalidJsonResponse_throws() async {
        await assertAsyncThrows(expected: Error.invalidJsonResponse) {
            _ = try ImageGenerationServiceResponse.decode(Data())
        }
    }
    
    func test_decode_withEmptyResponse_throws() async {
        await assertAsyncThrows(expected: Error.emptyResponse) {
            guard let mockData = "[[]]".data(using: .utf8) else {
                XCTFail("Could not create mock json data.")
                return
            }
            
            _ = try ImageGenerationServiceResponse.decode(mockData)
        }
    }
}

