import Foundation

protocol ImageGenerationServiceRequesting {
    var request: URLRequest { get }
    
    func prompt(_ string: String) throws -> Self
}

enum ImageGenerationServiceRequestingError: Error {
    case invalidPrompt
}

final class ImageGenerationServiceRequest: ImageGenerationServiceRequesting {
    private(set) var request: URLRequest
    
    init(endpoint: URL) {
        self.request = URLRequest(url: endpoint, timeoutInterval: 60.0)
    }
    
    func prompt(_ string: String) throws -> ImageGenerationServiceRequest {
        let httpBody = ImageRequestModel(
            steps: 40,
            width: 1024,
            height: 1024,
            seed: 0,
            cfgScale: 5,
            samples: 1,
            textPrompts: [
                .init(text: string, weight: 1),
                .init(text: "blurry, bad", weight: -1)
            ]
        )
        
        let encodedHttpBody = try JSONEncoder().encode(httpBody)
        
        request.httpBody = encodedHttpBody
        
        return self
    }
}
