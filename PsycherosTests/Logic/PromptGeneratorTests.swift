import XCTest

final class PromptGeneratorTests: XCTestCase {
    func test_zero() {
        let imagePrompt = ImagePrompt(color: "green", feelings: [.anxious])
        let expectedPrompt = "Generate a motivational image for someone who is feeling anxious, using the color green in an iphone ratio"
        let sut = PromptGenerator()
        
        let prompt = sut.writePrompt(with: imagePrompt)
        
        XCTAssertEqual(prompt, expectedPrompt)
    }
}

