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
        mimeType: String = "application/json"
    ) throws -> MockNetworkSession {
        let mock = MockNetworkSession()
        try mock.setResponse(statusCode: statusCode, mimeType: mimeType)
        
        return mock
    }
}
