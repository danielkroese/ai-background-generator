import XCTest

final class ImageSaverTests: XCTestCase {
    func test_saveImage_invalidUrl_throws() async {
        let sut = createSut()
        
        await assertAsyncThrows(expected: ImageSavingError.invalidUrl) {
            try await sut.save(image: URL(string: ""))
        }
    }
    
    func test_saveImage() async {
        let sut = createSut()
        
        let dummyImage = dummyImage
        
        await assertNoAsyncThrow {
            try await sut.save(image: dummyImage)
        }
    }
}

// MARK: - Test helpers
extension ImageSaverTests {
    private func createSut() -> ImageSaver {
        ImageSaver()
    }
    
    private var dummyImage: URL {
        let image = UIImage(resource: .dummy)

        let fileManager = FileManager.default
        let tempDirectory = fileManager.temporaryDirectory
        let imageURL = tempDirectory.appendingPathComponent("dummy_image.png")

        guard let imageData = image.pngData() else {
            XCTFail("Could not get png data from dummy image.")
            return URL.applicationDirectory
        }

        do {
            try imageData.write(to: imageURL)
            
            return imageURL
        } catch {
            XCTFail("Error saving image: \(error)")
            return URL.applicationDirectory
        }
    }
}

