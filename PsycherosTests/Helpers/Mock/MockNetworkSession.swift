import Foundation

enum MockNetworkSessionError: Error {
    case couldNotMockResponse
}

final class MockNetworkSession: NetworkSession {
    private(set) var didCallDataCount = 0
    private(set) var request: URLRequest?
    private(set) var data = Data()
    private(set) var response = HTTPURLResponse()
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        self.didCallDataCount += 1
        self.request = request
        
        return (data, response)
    }
    
    func setData(_ data: Data) {
        self.data = data
    }
    
    func setResponse(statusCode: Int) throws {
        guard let response = HTTPURLResponse(
            url: .homeDirectory,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        ) else {
            throw MockNetworkSessionError.couldNotMockResponse
        }
        
        self.response = response
    }
}
