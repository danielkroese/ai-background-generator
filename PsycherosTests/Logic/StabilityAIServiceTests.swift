import XCTest

final class StabilityAIServiceTests: XCTestCase {
    func test_setup_runsService() {
        do {
            let sut = try createSutAndSetup()
            
            XCTAssertTrue(sut.isRunning)
        } catch {
            XCTFail("Unexpected error.")
        }
    }
    
    func test_noSetup_doesNotRunService() {
        let sut = StabilityAIService()
        
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
extension StabilityAIServiceTests {
    private func createSutAndSetup() throws -> StabilityAIService {
        let sut = StabilityAIService()
        try sut.setup()
        
        return sut
    }
}
