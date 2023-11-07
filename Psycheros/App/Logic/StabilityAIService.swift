import Foundation

protocol AIService {
    var isRunning: Bool { get }
    
    func setup() throws
}

enum AIServiceError: Error {
    case alreadySetup
}

final class StabilityAIService: AIService {
    private(set) var isRunning = false
    
    func setup() throws {
        guard isRunning == false else {
            throw AIServiceError.alreadySetup
        }
        
        isRunning = true
    }
}
