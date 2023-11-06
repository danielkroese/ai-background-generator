import Foundation
import OpenAI

protocol AIService {
    var isRunning: Bool { get }
    
    func setup() throws
}

enum AIServiceError: Error {
    case alreadySetup
}

final class OpenAIService: AIService {
    private(set) var isRunning = false
    
    func setup() throws {
        guard isRunning == false else {
            throw AIServiceError.alreadySetup
        }
        
        isRunning = true
    }
}

protocol AIServiceWrapper {
    init(apiKey: String)
}

final class OpenAIServiceWrapper: AIServiceWrapper {
    init(apiKey: String) {
        <#code#>
    }
}
