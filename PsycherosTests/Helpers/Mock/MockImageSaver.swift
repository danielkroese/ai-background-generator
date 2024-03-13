import UIKit

final class MockImageSaver: NSObject, ImageSaving {
    private(set) var saveToPhotoAlbumImage: UIImage?
    private(set) var saveToPhotoAlbumCallCount = 0
    
    var saveToPhotoAlbumError: Error?
    
    func saveToPhotoAlbum(image: UIImage) async throws {
        saveToPhotoAlbumCallCount += 1
        saveToPhotoAlbumImage = image
        
        if let saveToPhotoAlbumError {
            throw saveToPhotoAlbumError
        }
    }
}
