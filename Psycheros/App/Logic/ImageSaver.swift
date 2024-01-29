import Foundation

protocol ImageSaving {
    func save(image: URL?) async throws
}

enum ImageSavingError: Error {
    case invalidUrl
}

final class ImageSaver: ImageSaving {
    func save(image imageUrl: URL?) async throws {
        guard let imageUrl, imageUrl.isFileURL else {
            throw ImageSavingError.invalidUrl
        }
    }
}
