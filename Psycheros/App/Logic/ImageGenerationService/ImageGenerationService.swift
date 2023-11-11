import Foundation

protocol ImageGenerationServicing {
    func fetchImage(model: ImageRequestModel) async throws -> URL
}

enum ImageGenerationServicingError: Error {
    case missingApiKey
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
        
        let imageData = try ImageGenerationServiceResponse
            .decodeFirstResponse(of: data)
            .imageData
                
        return URL.homeDirectory
    }
}
