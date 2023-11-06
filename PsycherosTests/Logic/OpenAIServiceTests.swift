import XCTest

final class OpenAIServiceTests: XCTestCase {
    func test_setup_runsService() {
        let sut = OpenAIService()
        
        do {
            try sut.setup()
        } catch {
            XCTFail("Unexpected error.")
        }
        
        XCTAssertTrue(sut.isRunning)
    }
    
    func test_noSetup_doesNotRunService() {
        let sut = OpenAIService()
        
        XCTAssertFalse(sut.isRunning)
    }
    
    func test_setup_twice_throws() {
        let expectation = XCTestExpectation(description: "throws alreadySetup")
        
        do {
            let sut = OpenAIService()
            try sut.setup()
            try sut.setup()
        } catch AIServiceError.alreadySetup {
            expectation.fulfill()
        } catch {
            XCTFail("Unexpected error.")
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
}
