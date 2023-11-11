import Foundation

struct ImageGenerationServiceResponse: Codable {
    let base64: String
    let finishReason: FinishReason
    let seed: Int
    
    enum FinishReason: String, Codable {
        case success,
             error,
             contentFiltered = "content_filtered",
             unknown
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawValue = try container.decode(String.self).lowercased()
            self = FinishReason(rawValue: rawValue) ?? .unknown
        }
    }
    
    static func decode(_ data: Data) throws -> [ImageGenerationServiceResponse] {
        guard let decodedResponse = try? JSONDecoder().decode(
            [[ImageGenerationServiceResponse]].self,
            from: data
        ) else {
            throw ImageGenerationServicingError.invalidJsonResponse
        }
        
        guard let unpackedResponse = decodedResponse.first else {
            throw ImageGenerationServicingError.emptyResponse
        }
        
        return unpackedResponse
    }
}
