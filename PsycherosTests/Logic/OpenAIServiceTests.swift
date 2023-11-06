import XCTest

final class OpenAIServiceTests: XCTestCase {
    func test_setup_runsService() {
        do {
            let sut = try createSutAndSetup()
            
            XCTAssertTrue(sut.isRunning)
        } catch {
            XCTFail("Unexpected error.")
        }
    }
    
    func test_noSetup_doesNotRunService() {
        let sut = OpenAIService()
        
        XCTAssertFalse(sut.isRunning)
    }
    
    func test_setup_twice_throws() {
        let expectation = XCTestExpectation(description: "throws alreadySetup")
        
        do {
            let sut = try createSutAndSetup()
            try sut.setup()
        } catch AIServiceError.alreadySetup {
            expectation.fulfill()
        } catch {
            XCTFail("Unexpected error.")
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
}

// MARK: - Test helpers
extension OpenAIServiceTests {
    private func createSutAndSetup() throws -> OpenAIService {
        let sut = OpenAIService()
        try sut.setup()
        
        return sut
    }
}
