import Foundation

enum ImageGenerationServiceResponseError: Error {
    case invalidJsonResponse,
         emptyResponse,
         invalidImageData
}

struct ImageGenerationServiceResponse: Codable, Equatable {
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
    
    var imageData: Data {
        get throws {
            guard let imageData = Data(base64Encoded: base64) else {
                throw ImageGenerationServiceResponseError.invalidImageData
            }
            
            return imageData
        }
    }
    
    static func decode(_ data: Data) throws -> [ImageGenerationServiceResponse] {
        guard let decodedResponse = try? JSONDecoder().decode(
            [[ImageGenerationServiceResponse]].self,
            from: data
        ) else {
            throw ImageGenerationServiceResponseError.invalidJsonResponse
        }
        
        guard let unpackedResponse = decodedResponse.first,
              unpackedResponse.isEmpty == false else {
            throw ImageGenerationServiceResponseError.emptyResponse
        }
        
        return unpackedResponse
    }
    
    static func decodeFirstResponse(of data: Data) throws -> ImageGenerationServiceResponse {
        guard let firstResult = try decode(data).first else {
            throw ImageGenerationServiceResponseError.emptyResponse
        }
        
        return firstResult
    }
}
