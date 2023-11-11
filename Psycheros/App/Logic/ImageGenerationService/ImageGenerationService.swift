import Foundation

protocol ImageGenerationServicing {
    func fetchImage(model: ImageRequestModel) async throws -> URL
}

enum ImageGenerationServicingError: Error {
    case missingApiKey,
         invalidImageData
}

final class ImageGenerationService: ImageGenerationServicing {
    private let bundle: Bundle
    private let networkSession: NetworkSession
    
    init(
        bundle: Bundle = Bundle.main,
        networkSession: NetworkSession = URLSession(configuration: .default)
    ) {
        self.bundle = bundle
        self.networkSession = networkSession
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
        
        let (data, response) = try await networkSession.data(for: request)
        
        try NetworkResponseValidator.validate(response)
        
        let imageResult = try ImageGenerationServiceResponse.decodeFirst(data)
        
        guard let imageData = Data(base64Encoded: imageResult.base64) else {
            throw ImageGenerationServicingError.invalidImageData
        }
                
        return URL.homeDirectory
    }
}
