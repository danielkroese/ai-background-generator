import Foundation

protocol NetworkResponseValidating {
    static func validate(_ response: URLResponse?) throws
}

enum NetworkResponseValidatingError: LocalizedError, Equatable {
    case invalidResponseType
    case invalidMimeType
    case serverError(statusCode: Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponseType: "Invalid response type, should be an HTTP response.."
        case .invalidMimeType: "Invalid reponse MIME type, should be application/json."
        case .serverError(let statusCode): "Server error: \(statusCode)."
        }
    }
}

struct NetworkResponseValidator: NetworkResponseValidating {
    static func validate(_ response: URLResponse?) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkResponseValidatingError.invalidResponseType
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkResponseValidatingError.serverError(statusCode: httpResponse.statusCode)
        }
        
        guard httpResponse.mimeType == "application/json" else {
            throw NetworkResponseValidatingError.invalidMimeType
        }
    }
}
