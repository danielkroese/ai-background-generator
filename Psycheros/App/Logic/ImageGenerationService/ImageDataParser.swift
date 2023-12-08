import Foundation

protocol DataParsing {
    func parseData() -> URL
}

final class ImageDataParser: DataParsing {
    func parseData() -> URL {
        return URL.desktopDirectory
    }
}
