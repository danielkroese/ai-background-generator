import XCTest
import Combine

extension XCTestCase {
    func assertNoThrow(
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (() throws -> Void)
    ) {
        do {
            try closure()
        } catch {
            fail(withUnexpected: error, file: file, line: line)
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
            fail(withUnexpected: error, file: file, line: line)
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
            fail(withNotThrown: error, file: file, line: line)
        } catch let caughtError as T {
            XCTAssertEqual(caughtError, error, "Unexpected error of type \(T.self) thrown", file: file, line: line)
        } catch {
            fail(withUnexpected: error, file: file, line: line)
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
            fail(withNotThrown: error, file: file, line: line)
        } catch let caughtError as T {
            XCTAssertEqual(caughtError, error, "Unexpected error of type \(T.self) thrown", file: file, line: line)
        } catch {
            fail(withUnexpected: error, file: file, line: line)
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

// MARK: - Combine
extension XCTestCase {
    func setsExpected<T: Equatable>(
        value: T,
        on publisher: some Publisher<T, Never>,
        storeIn subscriptions: inout Set<AnyCancellable>,
        action: () -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let expectation = XCTestExpectation(description: "Sets value")
        
        publisher
            .dropFirst()
            .sink { newValue in
                XCTAssertEqual(newValue, value, file: file, line: line)
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        action()
        
        wait(for: [expectation], timeout: 0.1)
    }
}
