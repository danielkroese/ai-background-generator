import Foundation

protocol ImageServiceRequesting {
    var request: URLRequest { get }
    
    func requestImage(_ imageRequest: ImageRequestModel) throws -> Self
}

enum ImageServiceRequestingError: LocalizedError {
    case invalidEndpoint
    
    var errorDescription: String? {
        switch self {
        case .invalidEndpoint: "Endpoint is not a valid URL."
        }
    }
}

final class ImageServiceRequest: ImageServiceRequesting {
    private(set) var request: URLRequest
    
    private enum Constants {
        static let endpoint = URL(string: "https://api.stability.ai/v1/generation/stable-diffusion-xl-1024-v1-0/text-to-image")
    }
    
    init(endpoint: URL? = Constants.endpoint,
         apiKey: String) throws {
        guard let endpoint else {
            throw ImageServiceRequestingError.invalidEndpoint
        }
        
        self.request = URLRequest(url: endpoint, timeoutInterval: 60.0)
        
        setHeaders(apiKey)
    }
    
    private func setHeaders(_ apiKey: String) {
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "POST"
    }

    func requestImage(_ imageRequest: ImageRequestModel) throws -> ImageServiceRequest {
        request.httpBody = try JSONEncoder().encode(imageRequest)
        
        return self
    }
}
