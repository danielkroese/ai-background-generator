import XCTest

final class GenerateImageRouterTests: XCTestCase {
    func test_toggleToolbar_toggles() {
        let sut = createSut()
        
        XCTAssertEqual(sut.presentedSubviews, [])
        
        sut.toggleToolbar()
        
        XCTAssertEqual(sut.presentedSubviews, [.tools])
        
        sut.toggleToolbar()
        
        XCTAssertEqual(sut.presentedSubviews, [])
    }
}

// MARK: - Test helpers
extension GenerateImageRouterTests {
    private func createSut() -> GenerateImageRouter {
        GenerateImageRouter()
    }
}

