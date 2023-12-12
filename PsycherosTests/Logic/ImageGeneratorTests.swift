import XCTest
import SwiftUI
import Combine

final class ImageGeneratorTests: XCTestCase {
    func test_generate_withInvalidPrompt_throws() async {
        await assertAsyncThrows(expected: ImageGeneratingError.incompleteQuery) {
            let query = createQuery(color: "", themes: [])
            
            _ = try await createSutAndGenerate(with: query)
        }
    }
    
    func test_generate_withInvalidPrompt_emptyColor_throws() async {
        await assertAsyncThrows(expected: ImageGeneratingError.incompleteQuery) {
            let query = createQuery(color: "", themes: [.cyberpunk])
            
            _ = try await createSutAndGenerate(with: query)
        }
    }
    
    func test_generate_withValidPrompt_doesNotThrow() async {
        await assertNoAsyncThrow {
            _ = try await createSutAndGenerate(with: createQuery())
        }
    }
    
    func test_generate_returnsImage() async {
        await assertNoAsyncThrow {
            _ = try await createSutAndGenerate(with: createQuery())
        }
    }
    
    func test_generate_callsImageService() async {
        await assertNoAsyncThrow {
            let spyService = SpyImageService()
            let sut = createSut(imageService: spyService)
            
            _ = try await sut.generate(from: createQuery())
            
            XCTAssertEqual(spyService.didCallFetchImageCount, 1)
        }
    }
}

// MARK: - Helpers
extension ImageGeneratorTests {
    private func createSut(
        imageService: ImageServicing = SpyImageService()
    ) -> ImageGenerator {
        return ImageGenerator(imageService: imageService)
    }
    
    private func createSutAndGenerate(with prompt: ImageQuery) async throws -> Image {
        let sut = createSut()
        
        return try await sut.generate(from: prompt)
    }
    
    private func createQuery(
        color: String = "yellow",
        themes: [Theme] = [.island],
        size: ImageRequestModel.ImageSize = .size1024x1024
    ) -> ImageQuery {
        ImageQuery(color: color, themes: themes, size: size)
    }
}
