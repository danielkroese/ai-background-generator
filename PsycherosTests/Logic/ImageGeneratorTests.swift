import XCTest
import Combine

final class ImageGeneratorTests: XCTestCase {
    func test_generate_withInvalidPrompt_throws() async {
        await assertAsyncThrows(expected: ImageGeneratingError.incompleteQuery) {
            let prompt = ImageQuery(color: "", feelings: [])
            
            _ = try await createSutAndGenerate(with: prompt)
        }
    }
    
    func test_generate_withInvalidPrompt_emptyColor_throws() async {
        await assertAsyncThrows(expected: ImageGeneratingError.incompleteQuery) {
            let prompt = ImageQuery(color: "", feelings: [.anxious])
            
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
    
    func test_generate_callsImageGenerationService() async {
        await assertNoAsyncThrow {
            let spyService = SpyImageGenerationService()
            let sut = createSut(imageGenerationService: spyService)
            
            _ = try await sut.generate(from: dummyQuery)
            
            XCTAssertEqual(spyService.didCallFetchImageCount, 1)
        }
    }
}

// MARK: - Helpers
extension ImageGeneratorTests {
    private var dummyQuery: ImageQuery {
        ImageQuery(color: "yellow", feelings: [.happy])
    }
    
    private func createSut(
        imageGenerationService: ImageGenerationServicing = SpyImageGenerationService()
    ) -> ImageGenerator {
        return ImageGenerator(imageGenerationService: imageGenerationService)
    }
    
    private func createSutAndGenerate(with prompt: ImageQuery) async throws -> URL {
        let sut = createSut()
        
        return try await sut.generate(from: prompt)
    }
}
