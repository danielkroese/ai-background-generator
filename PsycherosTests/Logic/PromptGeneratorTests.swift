import XCTest

final class PromptGeneratorTests: XCTestCase {
    private typealias Sut = PromptGenerator
    
    func test_writePrompt_withGreen_returnsExpectedTextPrompt() {
        assertNoThrow {
            let imageQuery = ImageQuery(color: "green", feelings: [.anxious])
            let expectedPrompt = "Generate a motivational image for someone who is feeling anxious, using the color green in an iphone ratio"
            
            let prompt = try Sut.writePrompt(with: imageQuery)
            
            XCTAssertEqual(prompt, expectedPrompt)
        }
    }
    
    func test_writePrompt_withBlue_returnsExpectedTextPrompt() {
        assertNoThrow {
            let imageQuery = ImageQuery(color: "blue", feelings: [.grateful, .happy])
            let expectedPrompt = "Generate a motivational image for someone who is feeling grateful, happy, using the color blue in an iphone ratio"
            
            let prompt = try Sut.writePrompt(with: imageQuery)
            
            XCTAssertEqual(prompt, expectedPrompt)
        }
    }
    
    func test_writePrompt_withIncompletePrompt_throws() {
        assertThrows(expected: PromptGeneratingError.incompleteQuery) {
            let imageQuery = ImageQuery(color: "", feelings: [.grateful, .happy])
            
            _ = try Sut.writePrompt(with: imageQuery)
        }
    }
}

