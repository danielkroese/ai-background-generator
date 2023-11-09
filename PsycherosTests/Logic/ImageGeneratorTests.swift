import XCTest
import SwiftUI // ??
import Combine

final class ImageGeneratorTests: XCTestCase {
    func test_generate_withInvalidPrompt_throws() async {
        await assertThrowsAsync(expected: ImageGeneratingError.incompleteQuery) {
            let prompt = ImageQuery(color: "", feelings: [])
            
            _ = try await createSutAndGenerate(with: prompt)
        }
    }
    
    func test_generate_withInvalidPrompt_emptyColor_throws() async {
        await assertThrowsAsync(expected: ImageGeneratingError.incompleteQuery) {
            let prompt = ImageQuery(color: "", feelings: [.anxious])
            
            _ = try await createSutAndGenerate(with: prompt)
        }
    }
    
    func test_generate_withValidPrompt_doesNotThrow() async {
        await assertNoThrowAsync {
            _ = try await createSutAndGenerate(with: dummyQuery)
        }
    }
    
    func test_generate_returnsUrl() async {
        await assertNoThrowAsync {
            let image = try await createSutAndGenerate(with: dummyQuery)
            
            XCTAssertEqual(image, URL.picturesDirectory)
        }
    }
    
    func test_generate_callsPromptGenerator() async {
        await assertNoThrowAsync {
            let spy = SpyPromptGenerator()
            let sut = createSut(promptGenerator: spy)
            
            _ = try await sut.generate(from: dummyQuery)
            
            XCTAssertEqual(spy.didCallWritePromptCount, 1)
        }
    }
}

// MARK: - Helpers
extension ImageGeneratorTests {
    private var dummyQuery: ImageQuery {
        ImageQuery(color: "yellow", feelings: [.happy])
    }
    
    private func createSut(promptGenerator: PromptGenerating = SpyPromptGenerator()) -> ImageGenerator {
        return ImageGenerator(promptGenerator: promptGenerator)
    }
    
    private func createSutAndGenerate(with prompt: ImageQuery) async throws -> URL {
        let sut = createSut()
        
        return try await sut.generate(from: prompt)
    }
}
