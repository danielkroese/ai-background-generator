import XCTest

final class PromptGeneratorTests: XCTestCase {
    private typealias Sut = PromptGenerator
    
    func test_writePrompt_withGreen_returnsExpectedTextPrompt() {
        assertNoThrow {
            let imageQuery = ImageQuery(color: "green", themes: [.cyberpunk])
            let expectedPrompt = "a cyberpunk style landscape, with an overwhelming amount of the color green, in an iphone portrait ratio"
            
            let prompt = try Sut.writePrompt(with: imageQuery)
            
            XCTAssertEqual(prompt, expectedPrompt)
        }
    }
    
    func test_writePrompt_withBlue_returnsExpectedTextPrompt() {
        assertNoThrow {
            let imageQuery = ImageQuery(color: "blue", themes: [.island, .nature])
            let expectedPrompt = "a beautiful island with blue waters, with a lush tropical nature forest, with an overwhelming amount of the color blue, in an iphone portrait ratio"
            
            let prompt = try Sut.writePrompt(with: imageQuery)
            
            XCTAssertEqual(prompt, expectedPrompt)
        }
    }
    
    func test_writePrompt_withIncompletePrompt_throws() {
        assertThrows(expected: PromptGeneratingError.incompleteQuery) {
            let imageQuery = ImageQuery(color: "", themes: [.nature, .space])
            
            _ = try Sut.writePrompt(with: imageQuery)
        }
    }
}

