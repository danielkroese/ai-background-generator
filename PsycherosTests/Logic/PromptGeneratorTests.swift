import XCTest

final class PromptGeneratorTests: XCTestCase {
    func test_writePrompt_withGreen_returnsExpectedTextPrompt() {
        let imageQuery = ImageQuery(color: "green", feelings: [.anxious])
        let expectedPrompt = "Generate a motivational image for someone who is feeling anxious, using the color green in an iphone ratio"
        
        do {
            let prompt = try createSutAndWrite(with: imageQuery)
            
            XCTAssertEqual(prompt, expectedPrompt)
        } catch {
            XCTFail()
        }
    }
    
    func test_writePrompt_withBlue_returnsExpectedTextPrompt() {
        let imageQuery = ImageQuery(color: "blue", feelings: [.grateful, .happy])
        let expectedPrompt = "Generate a motivational image for someone who is feeling grateful, happy, using the color blue in an iphone ratio"
        
        do {
            let prompt = try createSutAndWrite(with: imageQuery)
            
            XCTAssertEqual(prompt, expectedPrompt)
        } catch {
            XCTFail()
        }
    }
    
    func test_writePrompt_withIncompletePrompt_throws() {
        let imageQuery = ImageQuery(color: "", feelings: [.grateful, .happy])
        let expectation = XCTestExpectation(description: "throws incompleteQuery")
        
        do {
            _ = try createSutAndWrite(with: imageQuery)
            
            XCTFail()
        } catch PromptGeneratingError.incompleteQuery {
            expectation.fulfill()
        } catch {
            XCTFail()
        }
    }
    
    private func createSutAndWrite(with prompt: ImageQuery) throws -> String {
        let sut = PromptGenerator()
        
        return try sut.writePrompt(with: prompt)
    }
}

