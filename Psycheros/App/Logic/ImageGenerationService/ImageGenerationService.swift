import Foundation

protocol ImageGenerationServicing {
    func fetchImage(model: ImageRequestModel) async throws -> URL
}

enum ImageGenerationServicingError: Error {
    case missingApiKey
    case invalidResponseType
    case invalidMimeType
    case serverError(statusCode: Int)
}

final class ImageGenerationService: ImageGenerationServicing {
    private let bundle: Bundle
    private let networkSession: NetworkSession
    
    init(bundle: Bundle = Bundle.main,
         networkSession: NetworkSession = URLSession(configuration: .default)) {
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
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ImageGenerationServicingError.invalidResponseType
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw ImageGenerationServicingError.serverError(statusCode: httpResponse.statusCode)
        }
        
        guard httpResponse.mimeType == "application/json" else {
            throw ImageGenerationServicingError.invalidMimeType
        }
        
        return URL.homeDirectory
    }
}
