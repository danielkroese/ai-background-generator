import XCTest

final class ImageGeneratorTests: XCTestCase {
    func test_zero() {
        let sut = ImageGenerator()
    }
    
    func test_sendPrompt() {
        let sut = ImageGenerator()
        
        let prompt = ImagePrompt(color: "yellow", feelings: [.happy])
        
        sut.send(prompt)
    }
}

