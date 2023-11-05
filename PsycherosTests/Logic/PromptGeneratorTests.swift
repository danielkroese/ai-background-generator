import XCTest

final class PromptGeneratorTests: XCTestCase {
    func test_writePrompt_withGreen_returnsExpectedTextPrompt() {
        let imagePrompt = ImagePrompt(color: "green", feelings: [.anxious])
        let expectedPrompt = "Generate a motivational image for someone who is feeling anxious, using the color green in an iphone ratio"
        let sut = PromptGenerator()
        
        let prompt = sut.writePrompt(with: imagePrompt)
        
        XCTAssertEqual(prompt, expectedPrompt)
    }
    
    func test_writePrompt_withBlue_returnsExpectedTextPrompt() {
        let imagePrompt = ImagePrompt(color: "blue", feelings: [.grateful, .happy])
        let expectedPrompt = "Generate a motivational image for someone who is feeling grateful, happy, using the color blue in an iphone ratio"
        let sut = PromptGenerator()
        
        let prompt = sut.writePrompt(with: imagePrompt)
        
        XCTAssertEqual(prompt, expectedPrompt)
    }
}

