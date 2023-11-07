import Foundation

protocol ImageGenerationServiceRequesting {
    var request: URLRequest { get }
}

enum ImageGenerationServiceRequestingError: Error {
    case invalidUrl
}

struct ImageGenerationServiceRequest: ImageGenerationServiceRequesting {
    private(set) var request: URLRequest
    
    init(endpoint: URL) {
        self.request = URLRequest(url: endpoint, timeoutInterval: 60.0)
    }
}

