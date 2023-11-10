import Foundation

final class MockNetworkSession: NetworkSession {
    private(set) var didCallDataCount = 0
    private(set) var request: URLRequest?
    
    var data = Data()
    var response = URLResponse()
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        self.didCallDataCount += 1
        self.request = request
        
        return (data, response)
    }
}
