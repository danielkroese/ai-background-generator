import XCTest

final class NetworkResponseValidatorTests: XCTestCase {
    func test_validate_withUnsuccessfulStatusCode_throws() async {
        for statusCode in [0, 100, 199, 300, 400, 500, 600] {
            await assertAsyncThrows(
                expected: NetworkResponseValidatingError.serverError(statusCode: statusCode)
            ) {
                let mockResponse = try createMockNetworkResponse(statusCode: statusCode)
                
                try NetworkResponseValidator.validate(mockResponse)
            }
        }
    }
    
    func test_validate_responseNotJson_throws() async {
        await assertAsyncThrows(expected: NetworkResponseValidatingError.invalidMimeType) {
            let mockResponse = try createMockNetworkResponse(mimeType: "notJson")
            
            try NetworkResponseValidator.validate(mockResponse)
            
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
