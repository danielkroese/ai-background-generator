import Foundation

enum ImageServiceResponseError: Error, Equatable {
    case invalidJsonResponse(DecodingError?),
         emptyResponse,
         artifactIndexNotFound,
         invalidImageData,
         finishedUnsuccesfully(ImageServiceResponse.FinishReason)
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}

struct ImageServiceResponse: Codable, Equatable {
    let artifacts: [[Artifact]]
    
    struct Artifact: Codable, Equatable {
        let base64: String
        let finishReason: FinishReason
        let seed: Int
        
        func verify() throws {
            guard finishReason == .success else {
                throw ImageServiceResponseError.finishedUnsuccesfully(finishReason)
            }
        }
    }
    
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
    
    static func decode(_ data: Data) throws -> ImageServiceResponse {
        let decoder = JSONDecoder()
        
        do {
            let decodedResponse = try decoder.decode(ImageServiceResponse.self, from: data)
            
            return decodedResponse
        } catch let decodingError as DecodingError {
            throw ImageServiceResponseError.invalidJsonResponse(decodingError)
        } catch {
            throw error
        }
    }
    
    static func decodeFirstArtifact(of data: Data) throws -> Artifact {
        guard let firstResult = try decode(data).artifacts.first?.first else {
            throw ImageServiceResponseError.emptyResponse
        }
        
        try firstResult.verify()
        
        return firstResult
    }
    
    static func artifact(_ index: Int, of data: Data) throws -> Artifact {
        guard let artifacts = try decode(data).artifacts.first else {
            throw ImageServiceResponseError.emptyResponse
        }
        
        guard artifacts.indices.contains(index) else {
            throw ImageServiceResponseError.artifactIndexNotFound
        }
        
        let artifact = artifacts[index]
        
        try artifact.verify()
        
        return artifact
    }
}
