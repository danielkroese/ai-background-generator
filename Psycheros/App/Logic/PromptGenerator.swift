import Foundation

protocol PromptGenerating {
    func writePrompt(with prompt: ImagePrompt) -> String
}

final class PromptGenerator: PromptGenerating {
    func writePrompt(with prompt: ImagePrompt) -> String {
        var feelings: [String] = []
        for feeling in prompt.feelings {
            feelings.append(feeling.rawValue)
        }
        
        return "Generate a motivational image for someone who is feeling \(feelings.joined(separator: ", ")), using the color \(prompt.color) in an iphone ratio"
    }
}
