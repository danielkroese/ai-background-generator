import Foundation

protocol ImageGenerating {
    func send(_: ImagePrompt) throws
}

enum ImageGeneratingError: Error {
    case invalidPrompt
}

final class ImageGenerator: ImageGenerating {
    func send(_ prompt: ImagePrompt) throws {
        guard prompt.color.isEmpty == false,
              prompt.feelings.isEmpty == false else {
            throw ImageGeneratingError.invalidPrompt
        }
    }
}
