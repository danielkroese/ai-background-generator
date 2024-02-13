import Foundation

protocol ImageServicing {
    func fetchImage(model: ImageRequestModel) async throws -> URL
}

enum ImageServicingError: LocalizedError {
    case missingApiKey
    
    var errorDescription: String? {
        switch self {
        case .missingApiKey: "Missing required API key in config (STABILITY_API_KEY)."
        }
    }
}

final class ImageService: ImageServicing {
    private let bundle: Bundle
    private let networkSession: NetworkSession
    private let imageDataParser: DataParsing
    
    init(
        bundle: Bundle = Bundle.main,
        networkSession: NetworkSession = URLSession(configuration: .default),
        imageDataParser: DataParsing = ImageDataParser()
    ) {
        self.bundle = bundle
        self.networkSession = networkSession
        self.imageDataParser = imageDataParser
    }
    
    private var apiKey: String {
        get throws {
            guard let apiKey = bundle.object(forInfoDictionaryKey: "STABILITY_API_KEY") as? String else {
                throw ImageServicingError.missingApiKey
            }
            
            return apiKey
        }
    }
    
    func fetchImage(model: ImageRequestModel) async throws -> URL {
        let request = try ImageServiceRequest(apiKey: apiKey)
            .requestImage(model)
            .request
        
        let (data, response) = try await networkSession.data(for: request)
        
        try NetworkResponseValidator.validate(response)
        
        let imageResponse = try ImageServiceResponse.decodeFirstArtifact(of: data)
        let imageUrl = try imageDataParser.parse(imageResponse.base64)
                
        return imageUrl
    }
}
