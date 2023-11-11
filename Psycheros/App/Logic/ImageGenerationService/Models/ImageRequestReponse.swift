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
        
        init(fromRawValue rawValue: String) {
            self = Self(rawValue: rawValue.lowercased()) ?? .unknown
        }
    }
}

