import Foundation

protocol ImageSaving {
    func save(image: URL)
}

final class ImageSaver: ImageSaving {
    func save(image: URL) {
        // ...
    }
}
