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
}
