import XCTest

final class ImageSaverTests: XCTestCase {
    func test_saveImage_invalidUrl_throws() async {
        let sut = createSut()
        
        await assertAsyncThrows(expected: ImageSavingError.invalidUrl) {
            try await sut.save(image: URL.applicationDirectory)
        }
    }
}

// MARK: - Test helpers
extension ImageSaverTests {
    private func createSut() -> ImageSaver {
        ImageSaver()
    }
}

