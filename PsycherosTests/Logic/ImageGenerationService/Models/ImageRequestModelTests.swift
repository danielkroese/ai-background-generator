import XCTest

final class ImageRequestModelTests: XCTestCase {
    func test_init_withEmptyPrompt_throws() {
        assertThrows(expected: ImageRequestModelError.emptyPrompt) {
            _ = try createSut(prompt: "")
        }
    }
    
    func test_init_withValidPrompt_succeeds() {
        assertNoThrow {
            _ = try createSut()
        }
    }
    
    func test_init_withAnySize_setsCorrectSizes() {
        assertNoThrow {
            for size in ImageRequestModel.ImageSize.allCases {
                let sut = try createSut(size: size)
                
                XCTAssertEqual(sut.width, size.width)
                XCTAssertEqual(sut.height, size.height)
            }
        }
    }
    
    func test_init_withNegativeSeed_throws() {
        assertThrows(expected: ImageRequestModelError.invalidSeed) {
            _ = try createSut(seed: -12)
        }
    }
    
    func test_init_withZeroSeed_succeeds() {
        assertNoThrow {
            _ = try createSut(seed: .zero)
        }
    }
    
    func test_init_withTooBigSeed_throws() {
        assertThrows(expected: ImageRequestModelError.invalidSeed) {
            _ = try createSut(seed: 4294967296)
        }
    }
    
    func test_init_setsValidWeights() {
        assertNoThrow {
            let sut = try createSut()
            
            sut.textPrompts.forEach {
                XCTAssertTrue($0.weight.isBetween(-1, and: 1))
            }
        }
    }
}

// MARK: - Test helpers
extension ImageRequestModelTests {
    private func createSut(prompt: String = "prompt",
                           seed: Int = 123,
                           size: ImageRequestModel.ImageSize = .size1024x1024) throws -> ImageRequestModel {
        try ImageRequestModel(prompt: prompt, seed: seed, size: size)
    }
}
