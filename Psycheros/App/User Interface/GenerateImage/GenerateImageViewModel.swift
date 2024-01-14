import Foundation
import SwiftUI

protocol GenerateImageViewModeling: ObservableObject {
    var isLoading: Bool { get }
    var errorText: String? { get }
    var generatedImage: Image? { get }
    
    var selectedColor: AllowedColor { get set }
    var selectedThemes: Set<Theme> { get set }
    
    func tappedGenerateImage()
}

final class GenerateImageViewModel: GenerateImageViewModeling {
    @Published var selectedColor: AllowedColor = .blue
    @Published var selectedThemes: Set<Theme> = [.cyberpunk, .space]
    
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorText: String?
    @Published private(set) var generatedImage: Image?
        
    private(set) var imageTask: Task<(), Never>?
    
    private let imageGenerator: ImageGenerating
    
    init(imageGenerator: ImageGenerating = ImageGenerator()) {
        self.imageGenerator = imageGenerator
    }
    
    deinit {
        imageTask?.cancel()
    }
    
    func tappedGenerateImage() {
        guard isLoading == false else {
            return
        }
        
        guard selectedThemes.isEmpty == false else {
            errorText = "Theme required"
            return
        }
        
        setLoading(true)
        setError(nil)
        
        generateImage(from: imageQuery)
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
    
    private func setError(_ error: Error?) {
        Task { @MainActor in
            guard let error else {
                errorText = nil
                return
            }
            
            errorText = (error as? ImageGeneratingError)?.rawValue ?? error.localizedDescription
        }
    }
    
    private func generateImage(from query: ImageQuery) {
        imageTask = Task {
            defer {
                setLoading(false)
            }
            
            do {
                let image = try await imageGenerator.generate(from: query)
                
                try Task.checkCancellation()
                
                setImage(from: image)
            } catch {
                setError(error)
            }
        }
    }
    
    private var imageQuery: ImageQuery {
        ImageQuery(
            color: selectedColor.rawValue,
            themes: selectedThemes,
            size: .size768x1344
        )
    }
}
