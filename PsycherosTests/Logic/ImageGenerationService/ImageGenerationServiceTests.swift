import XCTest

final class ImageGenerationServiceTests: XCTestCase {
    private typealias Error = ImageGenerationServicingError
    
    func test_fetchImage_returnsFileUrl() async {
        await assertNoAsyncThrow {
            let sut = try createSut()
            let url = try await sut.fetchImage(model: dummyModel)
            
            XCTAssertTrue(url.isFileURL)
        }
    }
    
    func test_fetchImage_withoutKeyInBundle_throws() async {
        await assertAsyncThrows(expected: Error.missingApiKey) {
            let sut = try createSut(bundle: Bundle())
            
            _ = try await sut.fetchImage(model: dummyModel)
        }
    }
    
    func test_fetchImage_startsNetworkSession() async {
        await assertNoAsyncThrow {
            let mockNetworkSession = try createMockNetworkSession()
            
            let sut = try createSut(networkSession: mockNetworkSession)
            
            _ = try await sut.fetchImage(model: dummyModel)
            
            XCTAssertEqual(mockNetworkSession.didCallDataCount, 1)
        }
    }
    
    // handle finish reason errors
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
    
    private func createMockResponseData(base64: String? = nil) throws -> Data {
        let mockResponse = [[ImageGenerationServiceResponse(
            base64: base64 ?? dummyBase64Image,
            finishReason: .success,
            seed: 1234
        )]]
        
        return try JSONEncoder().encode(mockResponse)
    }
    
    private var dummyModel: ImageRequestModel {
        get throws {
            try ImageRequestModel(prompt: "fake")
        }
    }
    
    private var dummyBase64Image: String { "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH5QgQChUkFOfjAAAAABl0RVh0Q29tbWVudABDcmVhdGVkIHdpdGggR0lNUFeBDhcAAAANSURBVAjXY2AAAAACAAHiIjUNAAAAAElFTkSuQmCC"
    }
}
