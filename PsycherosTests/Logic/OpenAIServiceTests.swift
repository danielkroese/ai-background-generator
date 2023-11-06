import XCTest

final class OpenAIServiceTests: XCTestCase {
    func test_setup_runsService() {
        let sut = OpenAIService()
        sut.setup()
        
        XCTAssertTrue(sut.isRunning)
    }
    
    func test_noSetup_doesNotRunService() {
        let sut = OpenAIService()
        
        XCTAssertFalse(sut.isRunning)
    }
}
