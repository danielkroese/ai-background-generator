import Foundation

protocol DataParsing {
    func parse(_ data: String) throws -> URL
}

enum DataParsingError: Error {
    case invalidImageData,
         saveDirectoryNotFound
}

final class ImageDataParser: DataParsing {
    func parse(_ base64: String) throws -> URL {
        let fileUrl = try fileUrl
        
        try data(from: base64).write(to: fileUrl)
        
        return fileUrl
    }
    
    private func data(from base64: String) throws -> Data {
        guard let imageData = Data(base64Encoded: base64) else {
            throw DataParsingError.invalidImageData
        }
        
        return imageData
    }
    
    private var documentDirectory: URL {
        get throws {
            guard let documentDirectory = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask
            ).first else {
                throw DataParsingError.saveDirectoryNotFound
            }
            
            return documentDirectory
        }
    }
    
    private var fileUrl: URL {
        get throws {
            let uniqueFileName = "background-\(UUID().uuidString)"
            
            return try documentDirectory.appendingPathComponent("\(uniqueFileName).png")
        }
    }
}
