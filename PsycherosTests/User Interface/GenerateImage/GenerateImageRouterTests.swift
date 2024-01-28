import XCTest
import Combine

final class GenerateImageRouterTests: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()
    
    override func tearDown() {
        subscriptions.removeAll()
        
        super.tearDown()
    }
    
    func test_toggle() async {
        let sut = createSut(initialSubviews: [])
        
        await setsExpected(value: [.themes], on: sut.publisher) {
            sut.toggle(.themes)
        }
        
        await setsExpected(value: [], on: sut.publisher) {
            sut.toggle(.themes)
        }
    }
    
    func test_present() async {
        let sut = createSut()
        
        await setsExpected(value: [.colors], on: sut.publisher) {
            sut.present(.colors)
        }
    }
    
    func test_dismiss() async {
        let sut = createSut(initialSubviews: [.tools, .themes])
        
        await setsExpected(value: [.tools], on: sut.publisher) {
            sut.dismiss(.themes)
        }
    }
    
    func test_dismissAll() async {
        let sut = createSut(initialSubviews: [.tools, .themes])
        
        await setsExpected(value: [], on: sut.publisher) {
            sut.dismissAll()
        }
    }
    
    func test_dismissAll_withException() async {
        let sut = createSut(initialSubviews: [.tools, .themes])
        
        await setsExpected(value: [.tools], on: sut.publisher) {
            sut.dismissAll(except: .tools)
        }
    }
    
    func test_isPresenting() async {
        let sut = createSut(initialSubviews: [.colors])
        
        XCTAssertTrue(sut.isPresenting(.colors))
        XCTAssertFalse(sut.isPresenting(.themes))
    }
}

// MARK: - Test helpers
extension GenerateImageRouterTests {
    private func createSut(
        initialSubviews: Set<GenerateImageDestination> = []
    ) -> GenerateImageRouter {
        GenerateImageRouter(presentedSubviews: initialSubviews)
    }
}

