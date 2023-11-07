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
        let httpBody: [String: Any] = [
            "steps": 40,
            "width": 1024,
            "height": 1024,
            "seed": 0,
            "cfg_scale": 5,
            "samples": 1,
            "text_prompts": [
              ["text": "scape, landscape, ecstatic, happy, color blue", "weight": 1],
              ["text": "blurry, bad, text", "weight": -1]
            ]
          ]
        
        let encodedHttpBody = try JSONSerialization.data(withJSONObject: httpBody, options: [])
        
        request.httpBody = encodedHttpBody
        
        return self
    }
}

