import XCTest

final class ImageGenerationServiceTests: XCTestCase {
    private typealias Error = ImageGenerationServicingError
    
    func test_fetchImage_returnsFileUrl() async {
        await assertNoAsyncThrow {
            let sut = try createSut()
            let url = try await sut.fetchImage(model: .init(prompt: "test"))
            
            XCTAssertTrue(url.isFileURL)
        }
    }
    
    func test_fetchImage_withoutKeyInBundle_throws() async {
        await assertAsyncThrows(expected: Error.missingApiKey) {
            let sut = try createSut(bundle: Bundle())
            
            _ = try await sut.fetchImage(model: .init(prompt: "test"))
        }
    }
    
    func test_fetchImage_startsNetworkSession() async {
        await assertNoAsyncThrow {
            let mockNetworkSession = try createMockNetworkSession()
            
            let sut = try createSut(networkSession: mockNetworkSession)
            
            _ = try await sut.fetchImage(model: .init(prompt: "test"))
            
            XCTAssertEqual(mockNetworkSession.didCallDataCount, 1)
        }
    }
    
    func test_fetchImage_withInvalidJsonResponse_throws() async {
        await assertAsyncThrows(expected: Error.invalidJsonResponse) {
            let mockNetworkSession = try createMockNetworkSession(responseData: Data())
            
            let sut = try createSut(networkSession: mockNetworkSession)
            
            _ = try await sut.fetchImage(model: .init(prompt: "test"))
        }
    }
}

// MARK: - Test helpers
extension ImageGenerationServiceTests {
    private func createSut(
        bundle: Bundle = Bundle.main,
        networkSession: NetworkSession? = nil
    ) throws -> ImageGenerationService {
        try ImageGenerationService(
            bundle: bundle,
            networkSession: networkSession ?? createMockNetworkSession()
        )
    }
    
    private func createMockNetworkSession(
        statusCode: Int = 200,
        mimeType: String = "application/json",
        responseData: Data? = nil
    ) throws -> MockNetworkSession {
        let mock = MockNetworkSession()
        try mock.setResponse(statusCode: statusCode, mimeType: mimeType)
        
        mock.mockData = try responseData ?? createMockResponseData()
        
        return mock
    }
    
    private func createMockResponseData() throws -> Data {
        let mockResponse = ImageGenerationServiceResponse(base64: "image", finishReason: .success, seed: 1234)
        
        return try JSONEncoder().encode(mockResponse)
    }
}
