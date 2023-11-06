import XCTest
import SwiftUI // ??
import Combine

final class ImageGeneratorTests: XCTestCase {
    func test_generate_withInvalidPrompt_throws() async {
        let expectation = XCTestExpectation(description: "throws incompleteQuery")
        let prompt = ImageQuery(color: "", feelings: [])
        
        do {
            _ = try await createSutAndGenerate(with: prompt)
        } catch ImageGeneratingError.incompleteQuery {
            expectation.fulfill()
        } catch {
            XCTFail()
        }
        
        await fulfillment(of: [expectation], timeout: 0.1)
    }
    
    func test_generate_withInvalidPrompt_emptyColor_throws() async {
        let expectation = XCTestExpectation(description: "throws incompleteQuery")
        let prompt = ImageQuery(color: "", feelings: [.anxious])
        
        do {
            _ = try await createSutAndGenerate(with: prompt)
        } catch ImageGeneratingError.incompleteQuery {
            expectation.fulfill()
        } catch {
            XCTFail()
        }
        
        await fulfillment(of: [expectation], timeout: 0.1)
    }
    
    func test_generate_withValidPrompt_doesNotThrow() async {
        do {
            _ = try await createSutAndGenerate(with: dummyQuery)
        } catch {
            XCTFail()
        }
    }
    
    func test_generate_returnsImage() async {
        do {
            let image = try await createSutAndGenerate(with: dummyQuery)
            
            XCTAssertEqual(image, Image(""))
        } catch {
            XCTFail()
        }
    }
    
    func test_generate_callsPromptGenerator() async {
        do {
            let spy = SpyPromptGenerator()
            let sut = createSut(promptGenerator: spy)
            
            _ = try await sut.generate(from: dummyQuery)
            
            XCTAssertEqual(spy.didCallWritePromptCount, 1)
        } catch {
            XCTFail()
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
    
    private func createSutAndGenerate(with prompt: ImageQuery) async throws -> Image {
        let sut = createSut()
        
        return try await sut.generate(from: prompt)
    }
}
