import XCTest

final class ImageServiceResponseTests: XCTestCase {
    private typealias Error = ImageServiceResponseError
    
    func test_decodedFromJson_hasExpectedValues() {
        assertNoThrow {
            let expectedResult = ImageServiceResponse(
                artifacts: [[
                    ImageServiceResponse.Artifact(
                        base64: "...very long string...",
                        finishReason: .success,
                        seed: 1050625087
                    ),
                    ImageServiceResponse.Artifact(
                        base64: "...very long string...",
                        finishReason: .contentFiltered,
                        seed: 1229191277
                    )
                ]]
            )
            
            guard let jsonData = """
            {
              "artifacts": [
                [
                  {
                    "base64": "...very long string...",
                    "finishReason": "SUCCESS",
                    "seed": 1050625087
                  },
                  {
                    "base64": "...very long string...",
                    "finishReason": "CONTENT_FILTERED",
                    "seed": 1229191277
                  }
                ]
              ]
            }
            """.data(using: .utf8) else {
                XCTFail("Could not create mock json data.")
                return
            }
            
            let decodedResults = try JSONDecoder().decode(
                ImageServiceResponse.self,
                from: jsonData
            )
            
            XCTAssertEqual(decodedResults.artifacts, expectedResult.artifacts)
        }
    }
    
    func test_decode_withInvalidJsonResponse_throws() async {
        await assertAsyncThrows(expected: Error.invalidJsonResponse(nil)) {
            _ = try ImageServiceResponse.decode(Data())
        }
    }
    
    func test_decodeFirstArtifact_withEmptyResponse_throws() async {
        await assertAsyncThrows(expected: Error.emptyResponse) {
            guard let mockData = "{\"artifacts\": [[]]}".data(using: .utf8) else {
                XCTFail("Could not create mock json data.")
                return
            }
            
            _ = try ImageServiceResponse.decodeFirstArtifact(of: mockData)
        }
    }
    
    func test_imageData_withInvalidBase64_throws() async {
        await assertAsyncThrows(expected: Error.invalidImageData) {
            let mockResponse = ImageServiceResponse(
                artifacts: [[ImageServiceResponse.Artifact(
                    base64: "???",
                    finishReason: .success,
                    seed: 123123
                )]]
            )
            
            _ = try mockResponse.artifacts.first?.first?.imageData
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
                    artifacts: [[ImageServiceResponse.Artifact(
                        base64: dummyBase64Image,
                        finishReason: finishReason,
                        seed: 123123
                    )]]
                )
                
                _ = try mockResponse.artifacts.first?.first?.imageData
            }
        }
    }
    
    private var dummyBase64Image: String { "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH5QgQChUkFOfjAAAAABl0RVh0Q29tbWVudABDcmVhdGVkIHdpdGggR0lNUFeBDhcAAAANSURBVAjXY2AAAAACAAHiIjUNAAAAAElFTkSuQmCC"
    }
}

