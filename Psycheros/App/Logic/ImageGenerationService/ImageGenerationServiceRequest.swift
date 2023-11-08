import Foundation

protocol ImageGenerationServiceRequesting {
    var request: URLRequest { get }
    
    func prompt(_ string: String, seed: Int, size: CGSize) throws -> Self
}

enum ImageGenerationServiceRequestingError: Error {
    case invalidEndpoint,
         invalidPrompt
}

final class ImageGenerationServiceRequest: ImageGenerationServiceRequesting {
    private(set) var request: URLRequest
    
    private enum Constants {
        static let steps = 40
        static let cfgScale = 5
        static let samples = 1
        static let negativePrompt = "blurry, bad, text"
        
        static let endpoint = URL(string: "https://api.stability.ai/v1/generation/stable-diffusion-xl-1024-v1-0/text-to-image")
    }
    
    init(endpoint: URL? = Constants.endpoint,
         apiKey: String) throws {
        guard let endpoint else {
            throw ImageGenerationServiceRequestingError.invalidEndpoint
        }
        
        self.request = URLRequest(url: endpoint, timeoutInterval: 60.0)
        
        setHeaders(apiKey)
    }
    
    private func setHeaders(_ apiKey: String) {
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    }

    func prompt(_ string: String,
                seed: Int = Int.random(in: Int.min...Int.max),
                size: CGSize = CGSize(width: 1024, height: 1024)) throws -> ImageGenerationServiceRequest {
        guard string.isEmpty == false else {
            throw ImageGenerationServiceRequestingError.invalidPrompt
        }
        
        let httpBody = ImageRequestModel(
            steps: Constants.steps,
            width: Int(size.width),
            height: Int(size.height),
            seed: seed,
            cfgScale: Constants.cfgScale,
            samples: Constants.samples,
            textPrompts: [
                .init(text: string, weight: 1),
                .init(text: Constants.negativePrompt, weight: -1)
            ]
        )
        
        let encodedHttpBody = try JSONEncoder().encode(httpBody)
        
        request.httpBody = encodedHttpBody
        
        return self
    }
}
