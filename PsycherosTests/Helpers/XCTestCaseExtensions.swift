import XCTest

extension XCTestCase {
    func assertNoThrow(
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (() throws -> Void)
    ) {
        do {
            try closure()
        } catch {
            fail(with: error)
        }
    }
    
    func assertNoAsyncThrow(
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (() async throws -> Void)
    ) async {
        do {
            try await closure()
        } catch {
            fail(with: error)
        }
    }
    
    func assertThrows<T: Error>(
        expected error: T,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (() throws -> Void)
    ) {
        let expectation = XCTestExpectation(description: "throws expected error \(error.localizedDescription)")
        
        do {
            try closure()
        } catch _ as T {
            expectation.fulfill()
        } catch {
            fail(with: error)
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func assertAsyncThrows<T: Error>(
        expected error: T,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (() async throws -> Void)
    ) async {
        let expectation = XCTestExpectation(description: "throws expected error \(error.localizedDescription)")
        
        do {
            try await closure()
        } catch _ as T {
            expectation.fulfill()
        } catch {
            fail(with: error)
        }
        
        await fulfillment(of: [expectation], timeout: 0.1)
    }
    
    private func fail(with error: Error,
                      file: StaticString = #file,
                      line: UInt = #line) {
        let errorString = error.localizedDescription
        XCTFail("Unexpected error: \(errorString)", file: file, line: line)
    }
}
