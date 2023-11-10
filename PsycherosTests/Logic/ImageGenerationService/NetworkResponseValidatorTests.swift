import XCTest

final class NetworkResponseValidatorTests: XCTestCase {
    private typealias Sut = NetworkResponseValidator
    
    func test_validate_withUnsuccessfulStatusCode_throws() {
        for statusCode in [0, 100, 199, 300, 400, 500, 600] {
            assertThrows(
                expected: NetworkResponseValidatingError.serverError(statusCode: statusCode)
            ) {
                let mockResponse = try createMockNetworkResponse(statusCode: statusCode)
                
                try Sut.validate(mockResponse)
            }
        }
    }
    
    func test_validate_responseNotJson_throws() {
        assertThrows(expected: NetworkResponseValidatingError.invalidMimeType) {
            let mockResponse = try createMockNetworkResponse(mimeType: "notJson")
            
            try Sut.validate(mockResponse)
        }
    }
    
    func test_validate_withInvalidResponse_throws() async {
        assertThrows(expected: NetworkResponseValidatingError.invalidResponseType) {
            let mockResponse = URLResponse()
            
            try Sut.validate(mockResponse)
        }
    }
}

// MARK: - Test helpers
extension NetworkResponseValidatorTests {
    private func createMockNetworkResponse(
        statusCode: Int = 200,
        mimeType: String = "application/json"
    ) throws -> URLResponse? {
        let mock = MockNetworkSession()
        try mock.setResponse(statusCode: statusCode, mimeType: mimeType)
        
        return mock.mockResponse
    }
}
