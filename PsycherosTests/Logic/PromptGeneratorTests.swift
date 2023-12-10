import XCTest

final class PromptGeneratorTests: XCTestCase {
    private typealias Sut = PromptGenerator
    
    func test_writePrompt_withGreen_returnsExpectedTextPrompt() {
        assertNoThrow {
            let imageQuery = createQuery(color: "green", themes: [.cyberpunk, .space])
            let expectedPrompt = "a cyberpunk style landscape, with outer space with galaxies and nebulas, with an overwhelming amount of the color green, in an iphone portrait ratio"
            
            let prompt = try Sut.writePrompt(with: imageQuery)
            
            XCTAssertEqual(prompt, expectedPrompt)
        }
    }
    
    func test_writePrompt_withBlue_returnsExpectedTextPrompt() {
        assertNoThrow {
            let imageQuery = createQuery(color: "blue", themes: [.island, .nature])
            let expectedPrompt = "a beautiful island with blue waters, with a lush tropical nature forest, with an overwhelming amount of the color blue, in an iphone portrait ratio"
            
            let prompt = try Sut.writePrompt(with: imageQuery)
            
            XCTAssertEqual(prompt, expectedPrompt)
        }
    }
    
    func test_writePrompt_withIncompletePrompt_throws() {
        assertThrows(expected: PromptGeneratingError.incompleteQuery) {
            let imageQuery = createQuery(color: "", themes: [.nature, .space])
            
            _ = try Sut.writePrompt(with: imageQuery)
        }
    }
}

// MARK: - Test helpers
extension PromptGeneratorTests {
    private func createQuery(
        color: String = "yellow",
        themes: [Theme] = [.island],
        size: ImageRequestModel.ImageSize = .size1024x1024
    ) -> ImageQuery {
        ImageQuery(color: color, themes: themes, size: size)
    }
}

