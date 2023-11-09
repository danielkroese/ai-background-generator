import XCTest

final class ImageRequestModelTests: XCTestCase {
    private let dummyPrompt = "prompt"
    
    func test_isValid_withEmptyPrompt_false() {
        let sut = ImageRequestModel(prompt: "")
        
        XCTAssertFalse(sut.isValid)
    }
    
    func test_isValid_withValidPrompt_true() {
        let sut = ImageRequestModel(prompt: dummyPrompt)
        
        XCTAssertTrue(sut.isValid)
    }
    
    func test_isValid_withNegativeHeight_false() {
        let sut = ImageRequestModel(prompt: dummyPrompt, size: CGSize(width: 100, height: -100))
        
        XCTAssertFalse(sut.isValid)
    }
    
    func test_isValid_withNegativeWidth_false() {
        let sut = ImageRequestModel(prompt: dummyPrompt, size: CGSize(width: -100, height: 100))
        
        XCTAssertFalse(sut.isValid)
    }
    
    func test_isValid_withPositiveWidth_true() {
        let sut = ImageRequestModel(prompt: dummyPrompt, size: CGSize(width: 100, height: 100))
        
        XCTAssertTrue(sut.isValid)
    }
    
    func test_isValid_withNegativeSeed_false() {
        let sut = ImageRequestModel(prompt: dummyPrompt, size: CGSize(width: 100, height: 100))
        
        XCTAssertTrue(sut.isValid)
    }
}

