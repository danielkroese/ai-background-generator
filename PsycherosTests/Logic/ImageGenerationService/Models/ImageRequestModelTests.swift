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
    
    func test_init_withAnySize_succeeds() {
        assertNoThrow {
            for size in ImageRequestModel.ImageSize.allCases {
                _ = try ImageRequestModel(prompt: dummyPrompt, size: size)
            }
        }
    }
    
    func test_init_withNegativeSeed_throws() {
        assertThrows(expected: ImageRequestModelError.invalidSeed) {
            _ = try ImageRequestModel(prompt: dummyPrompt, seed: -12)
        }
    }
    
    func test_init_withZeroSeed_succeeds() {
        assertNoThrow {
            _ = try ImageRequestModel(prompt: dummyPrompt, seed: .zero)
        }
    }
    
    func test_init_withTooBigSeed_throws() {
        assertThrows(expected: ImageRequestModelError.invalidSeed) {
            _ = try ImageRequestModel(prompt: dummyPrompt, seed: 4294967296)
        }
    }
}
