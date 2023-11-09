import Foundation

protocol ImageGenerationServicing {
    func fetchImage(model: ImageRequestModel) async throws -> URL
}

enum ImageGenerationServicingError: Error {
    case missingApiKey
}

final class ImageGenerationService: ImageGenerationServicing {
    private let bundle: Bundle
    
    init(bundle: Bundle = Bundle.main) {
        self.bundle = bundle
    }
    
    private var apiKey: String {
        get throws {
            guard let apiKey = bundle.object(forInfoDictionaryKey: "STABILITY_API_KEY") as? String else {
                throw ImageGenerationServicingError.missingApiKey
            }
            
            return apiKey
        }
    }
    
    func fetchImage(model: ImageRequestModel) async throws -> URL {
        let request = try ImageGenerationServiceRequest(apiKey: apiKey)
            .requestImage(model)
            .request
        
        // mock url session to use here
        
        return URL.homeDirectory
    }
}
