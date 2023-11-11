import XCTest

final class ImageGenerationServiceResponseTests: XCTestCase {
    func test_decodedFromJson_hasExpectedValues() {
        assertNoThrow {
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
            
            let decodedResults = try JSONDecoder().decode([[ImageGenerationServiceResponse]].self, from: jsonData).first
            
        }
    }
}

