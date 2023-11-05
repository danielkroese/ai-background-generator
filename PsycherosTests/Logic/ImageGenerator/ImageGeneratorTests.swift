import XCTest
import SwiftUI // ??
import Combine

final class ImageGeneratorTests: XCTestCase {
    private func createSut() -> ImageGenerator {
        return ImageGenerator()
    }
    
    func test_generate_withPrompt_doesNotThrow() async {
        let sut = createSut()
        
        let prompt = ImagePrompt(color: "yellow", feelings: [.happy])
        
        do {
            _ = try await sut.generate(from: prompt)
        } catch {
            XCTFail()
        }
    }
    
    func test_generate_withInvalidPrompt_throws() async {
        let expectation = XCTestExpectation(description: "throws invalidPrompt")
        
        let sut = createSut()
        
        let prompt = ImagePrompt(color: "", feelings: [])
        
        do {
            _ = try await sut.generate(from: prompt)
        } catch ImageGeneratingError.incompletePrompt {
            expectation.fulfill()
        } catch {
            XCTFail()
        }
        
        await fulfillment(of: [expectation], timeout: 0.1)
    }
    
    func test_generate_withInvalidPrompt_emptyColor_throws() async {
        let expectation = XCTestExpectation(description: "throws invalidPrompt")
        
        let sut = createSut()
        
        let prompt = ImagePrompt(color: "", feelings: [.anxious])
        
        do {
            _ = try await sut.generate(from: prompt)
        } catch ImageGeneratingError.incompletePrompt {
            expectation.fulfill()
        } catch {
            XCTFail()
        }
        
        await fulfillment(of: [expectation], timeout: 0.1)
    }
    
    func test_generate_returnsImage() async {
        let sut = createSut()
        
        let prompt = ImagePrompt(color: "yellow", feelings: [.happy])
        
        do {
            let image = try await sut.generate(from: prompt)
            
            XCTAssertEqual(image, Image(""))
        } catch {
            XCTFail()
        }
    }
}

