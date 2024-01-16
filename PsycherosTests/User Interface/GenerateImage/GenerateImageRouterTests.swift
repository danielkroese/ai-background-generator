import XCTest
import Combine

final class GenerateImageRouterTests: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()
    
    override func tearDown() {
        subscriptions.removeAll()
        
        super.tearDown()
    }
    
    func test_toggle() {
        let sut = createSut(initialSubviews: [])
        
        setsExpected(value: [.tools], on: sut.publisher, storeIn: &subscriptions) {
            sut.toggle(.tools)
        }
        
        setsExpected(value: [], on: sut.publisher, storeIn: &subscriptions) {
            sut.toggle(.tools)
        }
    }
    
    func test_present() {
        let sut = createSut()
        
        setsExpected(value: [.colors], on: sut.publisher, storeIn: &subscriptions) {
            sut.present(.colors)
        }
    }
    
    func test_dismiss() {
        let sut = createSut(initialSubviews: [.tools, .themes])
        
        setsExpected(value: [.tools], on: sut.publisher, storeIn: &subscriptions) {
            sut.dismiss(.themes)
        }
    }
    
    func test_dismissAll() {
        let sut = createSut(initialSubviews: [.tools, .themes])
        
        setsExpected(value: [], on: sut.publisher, storeIn: &subscriptions) {
            sut.dismissAll()
        }
    }
    
    func test_dismissAll_withException() {
        let sut = createSut(initialSubviews: [.tools, .themes])
        
        setsExpected(value: [.tools], on: sut.publisher, storeIn: &subscriptions) {
            sut.dismissAll(except: .tools)
        }
    }
    
    func test_isPresenting() {
        let sut = createSut(initialSubviews: [.colors])
        
        XCTAssertTrue(sut.isPresenting(.colors))
        XCTAssertFalse(sut.isPresenting(.themes))
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

