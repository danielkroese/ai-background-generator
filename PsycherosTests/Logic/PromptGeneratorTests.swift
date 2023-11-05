import XCTest

final class PromptGeneratorTests: XCTestCase {
    func test_writePrompt_withGreen_returnsExpectedTextPrompt() {
        let imagePrompt = ImagePrompt(color: "green", feelings: [.anxious])
        let expectedPrompt = "Generate a motivational image for someone who is feeling anxious, using the color green in an iphone ratio"
        
        do {
            let prompt = try createSutAndWrite(with: imagePrompt)
            
            XCTAssertEqual(prompt, expectedPrompt)
        } catch {
            XCTFail()
        }
    }
    
    func test_writePrompt_withBlue_returnsExpectedTextPrompt() {
        let imagePrompt = ImagePrompt(color: "blue", feelings: [.grateful, .happy])
        let expectedPrompt = "Generate a motivational image for someone who is feeling grateful, happy, using the color blue in an iphone ratio"
        
        do {
            let prompt = try createSutAndWrite(with: imagePrompt)
            
            XCTAssertEqual(prompt, expectedPrompt)
        } catch {
            XCTFail()
        }
    }
    
    func test_writePrompt_withIncompletePrompt_throws() {
        let imagePrompt = ImagePrompt(color: "", feelings: [.grateful, .happy])
        let expectation = XCTestExpectation(description: "throws incompletePrompt")
        
        do {
            _ = try createSutAndWrite(with: imagePrompt)
            
            XCTFail()
        } catch PromptGeneratingError.incompletePrompt {
            expectation.fulfill()
        } catch {
            XCTFail()
        }
    }
    
    private func createSutAndWrite(with prompt: ImagePrompt) throws -> String {
        let sut = PromptGenerator()
        
        return try sut.writePrompt(with: prompt)
    }
}

