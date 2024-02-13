import XCTest

final class ImageServiceResponseTests: XCTestCase {
    private typealias Error = ImageServiceResponseError
    
    func test_decodedFromJson_hasExpectedValues() {
        assertNoThrow {
            let expectedResult = createReponse(
                artifacts: [
                    createArtifact(
                        base64: "...very long string...",
                        finishReason: .success,
                        seed: 1050625087
                    ),
                    createArtifact(
                        base64: "...very long string...",
                        finishReason: .contentFiltered,
                        seed: 1229191277
                    )
                ]
            )
            
            guard let jsonData = """
            {
              "artifacts": [
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
            guard let mockData = "{\"artifacts\": []}".data(using: .utf8) else {
                XCTFail("Could not create mock json data.")
                return
            }
            
            _ = try ImageServiceResponse.decodeFirstArtifact(of: mockData)
        }
    }
    
    func test_decodeFirstArtifact_withoutFinishReasonSuccess_throws() async {
        let unsuccesfulFinishReasons: [ImageServiceResponse.FinishReason] = [
            .error,
            .contentFiltered,
            .unknown
        ]
        
        for finishReason in unsuccesfulFinishReasons {
            await assertAsyncThrows(expected: Error.finishedUnsuccesfully(finishReason)) {
                let mockResponse = createReponse(
                    artifacts: [createArtifact(finishReason: finishReason)]
                )
                
                let encodedResponse = try JSONEncoder().encode(mockResponse)
                
                _ = try ImageServiceResponse.decodeFirstArtifact(of: encodedResponse)
            }
        }
    }
    
    func test_artifact_invalidIndex_throws() {
        assertThrows(expected: Error.emptyResponse) {
            let mockResponse = createReponse()
            let encodedResponse = try JSONEncoder().encode(mockResponse)
            
            _ = try ImageServiceResponse.artifact(2, of: encodedResponse)
        }
    }
}

// MARK: - Test helpers
extension ImageServiceResponseTests {
    private func createReponse(
        artifacts: [ImageServiceResponse.Artifact]? = nil
    ) -> ImageServiceResponse {
        ImageServiceResponse(
            artifacts: artifacts ?? [createArtifact()]
        )
    }
    
    private func createArtifact(
        base64: String? = nil,
        finishReason: ImageServiceResponse.FinishReason = .success,
        seed: Int = 123123
    ) -> ImageServiceResponse.Artifact {
        ImageServiceResponse.Artifact(
            base64: base64 ?? dummyBase64Image,
            finishReason: finishReason,
            seed: seed
        )
    }
    
    private var dummyBase64Image: String {
        "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH5QgQChUkFOfjAAAAABl0RVh0Q29tbWVudABDcmVhdGVkIHdpdGggR0lNUFeBDhcAAAANSURBVAjXY2AAAAACAAHiIjUNAAAAAElFTkSuQmCC"
    }
}
