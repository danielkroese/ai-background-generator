import XCTest

final class ImageGenerationServiceTests: XCTestCase {
    func test_requestImage_returnsString() async {
        await assertNoThrowAsync {
            let sut = ImageGenerationService()
            let string = try await sut.requestImage(query: ImageQuery(color: "red", feelings: [.anxious, .grateful]))
            
            XCTAssertEqual(string, "")
        }
    }
}
