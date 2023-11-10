import XCTest

final class ImageGenerationServiceTests: XCTestCase {
    func test_fetchImage_returnsFileUrl() async {
        await assertNoThrowAsync {
            let sut = ImageGenerationService()
            let url = try await sut.fetchImage(model: .init(prompt: "test"))
            
            XCTAssertTrue(url.isFileURL)
        }
    }
    
    func test_fetchImage_withoutKeyInBundle_throws() async {
        await assertThrowsAsync(expected: ImageGenerationServicingError.missingApiKey) {
            let sut = ImageGenerationService(bundle: Bundle())
            
            _ = try await sut.fetchImage(model: .init(prompt: "test"))
        }
    }
    
    func test_fetchImage_startsNetworkSession() async {
        await assertNoThrowAsync {
            let mockNetworkSession = MockNetworkSession()
            let sut = ImageGenerationService(networkSession: mockNetworkSession)
            
            _ = try await sut.fetchImage(model: .init(prompt: "test"))
            
            XCTAssertEqual(mockNetworkSession.didCallDataCount, 1)
        }
    }
}
