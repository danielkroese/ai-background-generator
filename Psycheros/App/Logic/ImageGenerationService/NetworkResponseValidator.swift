import Foundation

protocol NetworkResponseValidating {
    static func validate(_ response: URLResponse?) throws
}

enum NetworkResponseValidatingError: Error {
    case invalidResponseType
    case invalidMimeType
    case serverError(statusCode: Int)
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
