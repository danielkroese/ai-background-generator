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
            fail(withUnexpected: error)
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
            fail(withUnexpected: error)
        }
    }
    
    func assertThrows<T: Error & Equatable>(
        expected error: T,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (() throws -> Void)
    ) {
        do {
            try closure()
            fail(withNotThrown: error)
        } catch let caughtError as T {
            XCTAssertEqual(caughtError, error, "Unexpected error of type \(T.self) thrown", file: file, line: line)
        } catch {
            fail(withUnexpected: error)
        }
    }
    
    func assertAsyncThrows<T: Error & Equatable>(
        expected error: T,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (() async throws -> Void)
    ) async {
        do {
            try await closure()
            fail(withNotThrown: error)
        } catch let caughtError as T {
            XCTAssertEqual(caughtError, error, "Unexpected error of type \(T.self) thrown", file: file, line: line)
        } catch {
            fail(withUnexpected: error)
        }
    }
    
    private func fail(withUnexpected error: Error,
                      file: StaticString = #file,
                      line: UInt = #line) {
        let errorString = error.localizedDescription
        XCTFail("Unexpected error: \(errorString)", file: file, line: line)
    }
    
    private func fail(withNotThrown error: Error,
                      file: StaticString = #file,
                      line: UInt = #line) {
        let errorString = error.localizedDescription
        XCTFail("Unexpected error: \(errorString)", file: file, line: line)
    }
}
