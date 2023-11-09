import XCTest

final class ImageGenerationServiceTests: XCTestCase {
    func test_requestImage_returnsFileUrl() async {
        await assertNoThrowAsync {
            let sut = ImageGenerationService()
            let url = try await sut.fetchImage(model: .init(prompt: "test"))
            
            XCTAssertTrue(url.isFileURL)
        }
    }
}
