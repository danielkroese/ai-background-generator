import Foundation
import UIKit

protocol GenerateImageViewModeling: ObservableObject {
    var errorText: String { get }
    var uiImage: UIImage { get }
    
    func tappedGenerateImage()
}

final class GenerateImageViewModel: GenerateImageViewModeling {
    @Published private(set) var errorText: String = ""
    @Published private(set) var uiImage: UIImage = UIImage()
    
    private var imageTask: Task<(), Never>?
    
    private let imageGenerator: ImageGenerating
    
    init(imageGenerator: ImageGenerating = ImageGenerator()) {
        self.imageGenerator = imageGenerator
    }
    
    deinit {
        imageTask?.cancel()
    }
    
    func tappedGenerateImage() {
        let query = ImageQuery(
            color: "yellow",
            themes: [.nature, .island],
            size: .size896x1152
        )
        
        imageTask = Task {
            do {
                let imageUrl = try await imageGenerator.generate(from: query)
                
                try Task.checkCancellation()
                
                setImage(from: imageUrl)
            } catch {
                setError(error)
            }
        }
    }
    
    private func setImage(from imageUrl: URL) {
        Task { @MainActor in
            uiImage = UIImage(data: try Data(contentsOf: imageUrl)) ?? UIImage()
        }
    }
    
    private func setError(_ error: Error) {
        Task { @MainActor in
            errorText = error.localizedDescription
        }
    }
}
