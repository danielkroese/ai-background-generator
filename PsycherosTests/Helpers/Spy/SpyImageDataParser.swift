import Foundation

final class SpyImageDataParser: DataParsing {
    private(set) var didCallParseDataCount = 0
    
    func parse(_ data: Data) -> URL {
        didCallParseDataCount += 1
        
        return URL.applicationDirectory
    }
}
