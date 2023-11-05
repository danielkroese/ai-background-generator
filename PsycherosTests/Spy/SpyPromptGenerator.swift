import Foundation

final class SpyPromptGenerator: PromptGenerating {
    private(set) var didCallWritePromptCount = 0
    
    func writePrompt(with prompt: ImagePrompt) throws -> String {
        didCallWritePromptCount += 1
        
        return "prompt"
    }
}
