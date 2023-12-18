import Foundation
import SwiftUI

protocol GenerateImageViewModeling: ObservableObject {
    var isLoading: Bool { get }
    var errorText: String? { get }
    var generatedImage: Image? { get }
    
    func selected(themes: [Theme])
    func selected(color: Color)
    func tappedGenerateImage()
}

final class GenerateImageViewModel: GenerateImageViewModeling {
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorText: String?
    @Published private(set) var generatedImage: Image?
        
    private(set) var imageTask: Task<(), Never>?
    
    private var imageQuery = ImageQuery(
        color: "yellow",
        themes: [.nature, .island],
        size: .size768x1344
    )
    
    private let imageGenerator: ImageGenerating
    
    init(imageGenerator: ImageGenerating = ImageGenerator()) {
        self.imageGenerator = imageGenerator
    }
    
    deinit {
        imageTask?.cancel()
    }
    
    func selected(themes: [Theme]) {
        guard themes.isEmpty == false else {
            errorText = "Theme required"
            return
        }
        
        imageQuery.themes = themes
    }
    
    func selected(color: Color) {
        imageQuery.color = color.description
    }
    
    func tappedGenerateImage() {
        guard isLoading == false else {
            return
        }
        
        setLoading(true)
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
    
    private func setError(_ error: Error) {
        Task { @MainActor in
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
}
