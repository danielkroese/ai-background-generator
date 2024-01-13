import XCTest

final class GenerateImageRouterTests: XCTestCase {
    func test_toggle() {
        let sut = createSut(initialSubviews: [])
        
        sut.toggle(.tools)
        
        XCTAssertEqual(sut.presentedSubviews, [.tools])
        
        sut.toggle(.tools)
        
        XCTAssertEqual(sut.presentedSubviews, [])
    }
    
    func test_present() {
        let sut = createSut()
        
        sut.present(.colors)
        
        XCTAssertEqual(sut.presentedSubviews, [.colors])
    }
    
    func test_dismiss() {
        let sut = createSut(initialSubviews: [.tools, .themes])
        
        sut.dismiss(.themes)
        
        XCTAssertEqual(sut.presentedSubviews, [.tools])
    }
    
    func test_dismissAll() {
        let sut = createSut(initialSubviews: [.tools, .themes])
        
        sut.dismissAll()
        
        XCTAssertEqual(sut.presentedSubviews, [])
    }
    
    func test_dismissAll_withException() {
        let sut = createSut(initialSubviews: [.tools, .themes])
        
        sut.dismissAll(except: .tools)
        
        XCTAssertEqual(sut.presentedSubviews, [.tools])
    }
}

// MARK: - Test helpers
extension GenerateImageRouterTests {
    private func createSut(
        initialSubviews: Set<GenerateImageSubview> = []
    ) -> GenerateImageRouter {
        GenerateImageRouter(presentedSubviews: initialSubviews)
    }
}

