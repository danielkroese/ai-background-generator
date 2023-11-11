import Foundation

struct ImageGenerationServiceResponse: Codable {
    let base64: String
    let finishReason: FinishReason
    let seed: Int
    
    enum FinishReason: String, Codable, Equatable {
        case success,
             error,
             contentFiltered = "content_filtered",
             unknown
        
        init(_ rawValue: String) {
            self = FinishReason(rawValue: rawValue) ?? .unknown
        }
    }
}

