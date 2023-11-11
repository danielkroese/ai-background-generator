import Foundation

protocol ImageGenerationServicing {
    func fetchImage(model: ImageRequestModel) async throws -> URL
}

enum ImageGenerationServicingError: Error {
    case missingApiKey
    case invalidJsonResponse
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
        
        let imageResponse = try decode(data)
        
        _ = imageResponse.base64
        
        return URL.homeDirectory
    }
    
    private func decode(_ data: Data) throws -> ImageGenerationServiceResponse {
        do {
            return try JSONDecoder().decode(ImageGenerationServiceResponse.self, from: data)
        } catch {
            throw ImageGenerationServicingError.invalidJsonResponse
        }
    }
}
