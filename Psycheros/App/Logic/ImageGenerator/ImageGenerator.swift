import Foundation

protocol ImageGenerating {
    func send(_: ImagePrompt) throws
}

enum ImageGeneratingError: Error {
    case invalidPrompt
}

final class ImageGenerator: ImageGenerating {
    func send(_ prompt: ImagePrompt) throws {
        // ...
        if prompt == ImagePrompt(color: "", feelings: []) {
            throw ImageGeneratingError.invalidPrompt 
        }
    }
}
