import Foundation

protocol PromptGenerating {
    func writePrompt(with prompt: ImagePrompt) -> String
}

final class PromptGenerator: PromptGenerating {
    func writePrompt(with prompt: ImagePrompt) -> String {
        return "Generate a motivational image for someone who is feeling anxious, using the color green in an iphone ratio"
    }
}
