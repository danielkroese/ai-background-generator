import XCTest

final class ImageRequestModelTests: XCTestCase {
    private let dummyPrompt = "prompt"
    
    func test_init_withEmptyPrompt_throws() {
        assertThrows(expected: ImageRequestModelError.emptyPrompt) {
            _ = try ImageRequestModel(prompt: "")
        }
    }
    
    func test_init_withValidPrompt_succeeds() {
        assertNoThrow {
            _ = try ImageRequestModel(prompt: dummyPrompt)
        }
    }
    
    func test_init_withNegativeHeight_throws() {
        assertThrows(expected: ImageRequestModelError.invalidSize) {
            _ = try ImageRequestModel(prompt: dummyPrompt, size: CGSize(width: 100, height: -100))
        }
    }
    
    func test_init_withNegativeWidth_throws() {
        assertThrows(expected: ImageRequestModelError.invalidSize) {
            _ = try ImageRequestModel(prompt: dummyPrompt, size: CGSize(width: -100, height: 100))
        }
    }
    
    func test_init_withPositiveWidth_succeeds() {
        assertNoThrow {
            _ = try ImageRequestModel(prompt: dummyPrompt, size: CGSize(width: 100, height: 100))
        }
    }
    
    func test_init_withNegativeSeed_throws() {
        assertThrows(expected: ImageRequestModelError.invalidSeed) {
            _ = try ImageRequestModel(prompt: dummyPrompt, seed: -12)
        }
    }
}

