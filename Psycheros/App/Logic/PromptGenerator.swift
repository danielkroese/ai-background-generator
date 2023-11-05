import Foundation

protocol PromptGenerating {
    func writePrompt(with prompt: ImagePrompt) throws -> String
}

enum PromptGeneratingError: Error {
    case incompletePrompt
}

final class PromptGenerator: PromptGenerating {
    func writePrompt(with prompt: ImagePrompt) throws -> String {
        guard prompt.isEmpty == false else {
            throw PromptGeneratingError.incompletePrompt
        }
        
        let feelings = parse(feelings: prompt.feelings)
        
        return "Generate a motivational image " +
        "for someone who is feeling \(feelings), " +
        "using the color \(prompt.color) in an iphone ratio"
    }
    
    private func parse(feelings: [Feeling]) -> String {
        var strings: [String] = []
        
        for feeling in feelings {
            strings.append(feeling.rawValue)
        }
        
        return strings.joined(separator: ", ")
    }
}
