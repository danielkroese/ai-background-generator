import XCTest
import SwiftUI // ??
import Combine

final class ImageGeneratorTests: XCTestCase {
    func test_generate_withInvalidPrompt_throws() async {
        let expectation = XCTestExpectation(description: "throws invalidPrompt")
        let prompt = ImagePrompt(color: "", feelings: [])
        
        do {
            _ = try await createSutAndGenerate(with: prompt)
        } catch ImageGeneratingError.incompletePrompt {
            expectation.fulfill()
        } catch {
            XCTFail()
        }
        
        await fulfillment(of: [expectation], timeout: 0.1)
    }
    
    func test_generate_withInvalidPrompt_emptyColor_throws() async {
        let expectation = XCTestExpectation(description: "throws invalidPrompt")
        let prompt = ImagePrompt(color: "", feelings: [.anxious])
        
        do {
            _ = try await createSutAndGenerate(with: prompt)
        } catch ImageGeneratingError.incompletePrompt {
            expectation.fulfill()
        } catch {
            XCTFail()
        }
        
        await fulfillment(of: [expectation], timeout: 0.1)
    }
    
    func test_generate_withValidPrompt_doesNotThrow() async {
        do {
            _ = try await createSutAndGenerate(with: dummyPrompt)
        } catch {
            XCTFail()
        }
    }
    
    func test_generate_returnsImage() async {
        do {
            let image = try await createSutAndGenerate(with: dummyPrompt)
            
            XCTAssertEqual(image, Image(""))
        } catch {
            XCTFail()
        }
    }
}

// MARK: - Helpers
extension ImageGeneratorTests {
    private var dummyPrompt: ImagePrompt {
        ImagePrompt(color: "yellow", feelings: [.happy])
    }
    
    private func createSut() -> ImageGenerator {
        return ImageGenerator()
    }
    
    private func createSutAndGenerate(with prompt: ImagePrompt) async throws -> Image {
        let sut = createSut()
        
        return try await sut.generate(from: prompt)
    }
}

