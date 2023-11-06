import Foundation
import OpenAI

protocol AIService {
    var isRunning: Bool { get }
    
    func setup()
}

final class OpenAIService: AIService {
    private(set) var isRunning = false
    
    func setup() {
        isRunning = true
    }
}
