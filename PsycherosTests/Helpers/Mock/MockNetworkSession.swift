import Foundation

enum MockNetworkSessionError: Error {
    case couldNotMockResponse
}

final class MockNetworkSession: NetworkSession {
    private(set) var didCallDataCount = 0
    private(set) var request: URLRequest?
    
    var mockData: Data?
    var mockResponse: URLResponse?
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        self.didCallDataCount += 1
        self.request = request
        
        return (mockData ?? Data(), mockResponse ?? URLResponse())
    }
    
    func setResponse(statusCode: Int = 200,
                     mimeType: String? = "application/json") throws {
        guard let response = MockHTTPURLResponse(
            url: .homeDirectory,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        ) else {
            throw MockNetworkSessionError.couldNotMockResponse
        }
        
        response.mockMimeType = mimeType
        
        self.mockResponse = response
    }
}

final class MockHTTPURLResponse: HTTPURLResponse {
    var mockMimeType: String?

    override var mimeType: String? {
        return mockMimeType ?? super.mimeType
    }
}
