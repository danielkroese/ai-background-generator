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
            let url = try await sut.fetchImage(model: .init(prompt: "test"))
        }
    }
}
