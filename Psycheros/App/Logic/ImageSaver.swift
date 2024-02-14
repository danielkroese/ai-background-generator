import UIKit

protocol ImageSaving: NSObject {
    func saveToPhotoAlbum(image: UIImage) async throws
}

final class ImageSaver: NSObject, ImageSaving {
    func saveToPhotoAlbum(image: UIImage) async throws {
        try await withCheckedThrowingContinuation { continuation in
            let contextPointer = wrapInContextPointer(continuation)

            UIImageWriteToSavedPhotosAlbum(
                image,
                self,
                #selector(saveCompleted(_:didFinishSavingWithError:contextInfo:)),
                contextPointer
            )
        }
    }
    
    private func wrapInContextPointer(_ continuation: CheckedContinuation<Void, Error>) -> UnsafeMutableRawPointer {
        let context = SaveImageContext(continuation: continuation)
        
        return Unmanaged.passRetained(context).toOpaque()
    }

    @objc private func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let context = Unmanaged<SaveImageContext>
            .fromOpaque(contextInfo)
            .takeRetainedValue()
        
        if let error = error {
            context.continuation.resume(throwing: error)
        } else {
            context.continuation.resume(returning: ())
        }
    }

    private class SaveImageContext {
        let continuation: CheckedContinuation<Void, Error>

        init(continuation: CheckedContinuation<Void, Error>) {
            self.continuation = continuation
        }
    }
}
