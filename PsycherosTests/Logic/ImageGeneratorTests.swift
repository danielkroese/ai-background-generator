import XCTest
import Combine

final class ImageGeneratorTests: XCTestCase {
    func test_generate_withInvalidPrompt_throws() async {
        await assertAsyncThrows(expected: ImageGeneratingError.incompleteQuery) {
            let prompt = ImageQuery(color: "", themes: [])
            
            _ = try await createSutAndGenerate(with: prompt)
        }
    }
    
    func test_generate_withInvalidPrompt_emptyColor_throws() async {
        await assertAsyncThrows(expected: ImageGeneratingError.incompleteQuery) {
            let prompt = ImageQuery(color: "", themes: [.cyberpunk])
            
            _ = try await createSutAndGenerate(with: prompt)
        }
    }
    
    func test_generate_withValidPrompt_doesNotThrow() async {
        await assertNoAsyncThrow {
            _ = try await createSutAndGenerate(with: dummyQuery)
        }
    }
    
    func test_generate_returnsImageFileUrl() async {
        await assertNoAsyncThrow {
            let image = try await createSutAndGenerate(with: dummyQuery)
            
            XCTAssertTrue(image.isFileURL)
        }
    }
    
    func test_generate_callsImageService() async {
        await assertNoAsyncThrow {
            let spyService = SpyImageService()
            let sut = createSut(imageService: spyService)
            
            _ = try await sut.generate(from: dummyQuery)
            
            XCTAssertEqual(spyService.didCallFetchImageCount, 1)
        }
    }
}

// MARK: - Helpers
extension ImageGeneratorTests {
    private var dummyQuery: ImageQuery {
        ImageQuery(color: "yellow", themes: [.island])
    }
    
    private func createSut(
        imageService: ImageServicing = SpyImageService()
    ) -> ImageGenerator {
        return ImageGenerator(imageService: imageService)
    }
    
    private func createSutAndGenerate(with prompt: ImageQuery) async throws -> URL {
        let sut = createSut()
        
        return try await sut.generate(from: prompt)
    }
}
