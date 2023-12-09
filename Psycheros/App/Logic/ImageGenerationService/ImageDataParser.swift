import Foundation

protocol DataParsing {
    func parse(_ data: String) throws -> URL
}

final class ImageDataParser: DataParsing {
    func parse(_ base64: String) throws -> URL {
        let data = try data(from: base64)
        
        return URL(dataRepresentation: data, relativeTo: URL.picturesDirectory)!
    }
    
    private func data(from base64: String) throws -> Data {
        
        guard let imageData = Data(base64Encoded: base64) else {
            throw ImageServiceResponseError.invalidImageData
        }
        
        return imageData
    }
}
