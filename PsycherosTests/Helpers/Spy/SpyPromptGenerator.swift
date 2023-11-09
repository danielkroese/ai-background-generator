import Foundation

final class SpyPromptGenerator: PromptGenerating {
    private(set) var didCallWritePromptCount = 0
    private(set) var writePromptQuery: ImageQuery?
    var prompt: String = "prompt"
    
    func writePrompt(with query: ImageQuery) throws -> String {
        didCallWritePromptCount += 1
        writePromptQuery = query
        
        return prompt
    }
}
