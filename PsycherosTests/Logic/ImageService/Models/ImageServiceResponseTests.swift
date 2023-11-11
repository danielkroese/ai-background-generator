import XCTest

final class ImageServiceResponseTests: XCTestCase {
    private typealias Error = ImageServiceResponseError
    
    func test_decodedFromJson_hasExpectedValues() {
        assertNoThrow {
            let expectedFirstResult = ImageServiceResponse(
                base64: "...very long string...",
                finishReason: .success,
                seed: 1050625087
            )
            
            let expectedSecondResult = ImageServiceResponse(
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
            
            guard let decodedResults = try JSONDecoder().decode(
                [[ImageServiceResponse]].self,
                from: jsonData
            ).first else {
                XCTFail("Could not decode mock json data.")
                return
            }
            
            XCTAssertTrue(decodedResults.contains { $0 == expectedFirstResult })
            XCTAssertTrue(decodedResults.contains { $0 == expectedSecondResult })
        }
    }
    
    func test_decode_withInvalidJsonResponse_throws() async {
        await assertAsyncThrows(expected: Error.invalidJsonResponse) {
            _ = try ImageServiceResponse.decode(Data())
        }
    }
    
    func test_decode_withEmptyResponse_throws() async {
        await assertAsyncThrows(expected: Error.emptyResponse) {
            guard let mockData = "[[]]".data(using: .utf8) else {
                XCTFail("Could not create mock json data.")
                return
            }
            
            _ = try ImageServiceResponse.decode(mockData)
        }
    }
    
    func test_imageData_withInvalidBase64_throws() async {
        await assertAsyncThrows(expected: Error.invalidImageData) {
            let mockResponse = ImageServiceResponse(
                base64: "???",
                finishReason: .success,
                seed: 123123
            )
            
            _ = try mockResponse.imageData
        }
    }
    
    func test_imageData_withoutFinishReasonSuccess_throws() async {
        let unsuccesfulFinishReasons: [ImageServiceResponse.FinishReason] = [
            .error,
            .contentFiltered,
            .unknown
        ]
        
        for finishReason in unsuccesfulFinishReasons {
            await assertAsyncThrows(expected: Error.finishedUnsuccesfully(finishReason)) {
                let mockResponse = ImageServiceResponse(
                    base64: dummyBase64Image,
                    finishReason: finishReason,
                    seed: 123123
                )
                
                _ = try mockResponse.imageData
            }
        }
    }
    
    private var dummyBase64Image: String { "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH5QgQChUkFOfjAAAAABl0RVh0Q29tbWVudABDcmVhdGVkIHdpdGggR0lNUFeBDhcAAAANSURBVAjXY2AAAAACAAHiIjUNAAAAAElFTkSuQmCC"
    }
}

