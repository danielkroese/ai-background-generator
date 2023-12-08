import Foundation

protocol DataParsing {
    func parse(_ data: Data) -> URL
}

final class ImageDataParser: DataParsing {
    func parse(_ data: Data) -> URL {
        return URL(dataRepresentation: data, relativeTo: URL.picturesDirectory)!
    }
}
