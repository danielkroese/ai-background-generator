import Foundation

enum ImageServiceResponseError: Error {
    case invalidJsonResponse,
         emptyResponse,
         invalidImageData
}

struct ImageServiceResponse: Codable, Equatable {
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
                throw ImageServiceResponseError.invalidImageData
            }
            
            return imageData
        }
    }
    
    static func decode(_ data: Data) throws -> [ImageServiceResponse] {
        guard let decodedResponse = try? JSONDecoder().decode(
            [[ImageServiceResponse]].self,
            from: data
        ) else {
            throw ImageServiceResponseError.invalidJsonResponse
        }
        
        guard let unpackedResponse = decodedResponse.first,
              unpackedResponse.isEmpty == false else {
            throw ImageServiceResponseError.emptyResponse
        }
        
        return unpackedResponse
    }
    
    static func decodeFirstResponse(of data: Data) throws -> ImageServiceResponse {
        guard let firstResult = try decode(data).first else {
            throw ImageServiceResponseError.emptyResponse
        }
        
        return firstResult
    }
}
