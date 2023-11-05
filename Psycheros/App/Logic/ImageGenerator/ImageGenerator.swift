import Foundation

protocol ImageGenerating {
    func send(_: ImagePrompt)
}

final class ImageGenerator: ImageGenerating {
    func send(_: ImagePrompt) {
        // ...
    }
}
