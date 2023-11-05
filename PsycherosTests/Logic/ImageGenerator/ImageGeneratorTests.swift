import XCTest

final class ImageGeneratorTests: XCTestCase {
    private func createSut() -> ImageGenerator {
        return ImageGenerator()
    }
    
    func test_sendPrompt() {
        let sut = createSut()
        
        let prompt = ImagePrompt(color: "yellow", feelings: [.happy])
        
        do {
            try sut.send(prompt)
        } catch {
            XCTFail()
        }
    }
    
    func test_invalidPrompt_throws() {
        let expectation = XCTestExpectation(description: "throws invalidPrompt")
        
        let sut = createSut()
        
        let prompt = ImagePrompt(color: "", feelings: [])
        
        do {
            try sut.send(prompt)
        } catch ImageGeneratingError.incompletePrompt {
            expectation.fulfill()
        } catch {
            XCTFail()
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_invalidPrompt_emptyColor_throws() {
        let expectation = XCTestExpectation(description: "throws invalidPrompt")
        
        let sut = createSut()
        
        let prompt = ImagePrompt(color: "", feelings: [.anxious])
        
        do {
            try sut.send(prompt)
        } catch ImageGeneratingError.incompletePrompt {
            expectation.fulfill()
        } catch {
            XCTFail()
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
}

