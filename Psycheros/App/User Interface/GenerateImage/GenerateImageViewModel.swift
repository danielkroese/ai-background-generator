import Foundation
import SwiftUI

protocol GenerateImageViewModeling: ObservableObject {
    var isLoading: Bool { get }
    var errorText: String? { get }
    var generatedImage: Image? { get }
    
    func tappedGenerateImage()
}

final class GenerateImageViewModel: GenerateImageViewModeling {
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorText: String?
    @Published private(set) var generatedImage: Image?
    
    private var imageTask: Task<(), Never>?
    
    private let imageGenerator: ImageGenerating
    
    init(imageGenerator: ImageGenerating = ImageGenerator()) {
        self.imageGenerator = imageGenerator
    }
    
    deinit {
        imageTask?.cancel()
    }
    
    func tappedGenerateImage() {
        setLoading(true)
        
        let query = ImageQuery(
            color: "yellow",
            themes: [.nature, .island],
            size: .size768x1344
        )
        
        imageTask = Task {
            do {
                let image = try await imageGenerator.generate(from: query)
                
                try Task.checkCancellation()
                
                setImage(from: image)
            } catch {
                setError(error)
            }
            
            setLoading(false)
        }
    }
    
    private func setLoading(_ value: Bool) {
        Task { @MainActor in
            isLoading = value
        }
    }
    
    private func setImage(from image: Image) {
        Task { @MainActor in
            generatedImage = image
        }
    }
    
    private func setError(_ error: Error) {
        Task { @MainActor in
            errorText = error.localizedDescription
        }
    }
}
