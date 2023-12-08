import XCTest

final class ImageServiceTests: XCTestCase {
    private typealias Error = ImageServicingError
    
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
    
    func test_fetchImage_callsDataParser() async {
        await assertNoAsyncThrow {
            let spyDataParser = SpyImageDataParser()
            let sut = try createSut(imageDataParser: spyDataParser)
            
            _ = try await sut.fetchImage(model: dummyModel)
            
            XCTAssertEqual(spyDataParser.didCallParseDataCount, 1)
        }
    }
}

// MARK: - Test helpers
extension ImageServiceTests {
    private func createSut(
        bundle: Bundle = Bundle.main,
        networkSession: NetworkSession? = nil,
        imageDataParser: DataParsing = SpyImageDataParser()
    ) throws -> ImageService {
        try ImageService(
            bundle: bundle,
            networkSession: networkSession ?? createMockNetworkSession(),
            imageDataParser: imageDataParser
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
    
    private func createMockResponseData(
        base64: String = "",
        finishReason: ImageServiceResponse.FinishReason = .success,
        seed: Int = 0
    ) throws -> Data {
        let mockResponse = [[ImageServiceResponse(
            base64: base64,
            finishReason: finishReason,
            seed: seed
        )]]
        
        return try JSONEncoder().encode(mockResponse)
    }
    
    private var dummyModel: ImageRequestModel {
        get throws {
            try ImageRequestModel(prompt: "fake")
        }
    }
}
