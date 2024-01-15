import Foundation
import SwiftUI

protocol GenerateImageViewModeling: ObservableObject {
    var selectedColor: AllowedColor { get set }
    var selectedThemes: Set<Theme> { get set }
    
    var isLoading: Bool { get }
    var errorText: String? { get }
    var generatedImage: Image? { get }
    
    func onAppear()
    func isPresenting(_ subview: GenerateImageSubview) -> Bool
    func tapped(on destination: GenerateImageSubview)
    func tappedBackground()
}

final class GenerateImageViewModel: GenerateImageViewModeling {
    @Published var selectedColor: AllowedColor = .blue
    @Published var selectedThemes: Set<Theme> = [.cyberpunk, .space]
    
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorText: String?
    @Published private(set) var generatedImage: Image?
        
    private(set) var imageTask: Task<(), Never>?
    
    private let imageGenerator: ImageGenerating
    private let router: GenerateImageRouting
    
    init(
        imageGenerator: ImageGenerating = ImageGenerator(),
        router: GenerateImageRouting = GenerateImageRouter()
    ) {
        self.imageGenerator = imageGenerator
        self.router = router
    }
    
    deinit {
        imageTask?.cancel()
    }
    
    func onAppear() {
        router.present(.tools)
    }
    
    func isPresenting(_ subview: GenerateImageSubview) -> Bool {
        router.isPresenting(subview)
    }
    
    func tappedBackground() {
        if isLoading == false {
            router.dismissAll(except: .tools)
        }
    }
    
    func tapped(on destination: GenerateImageSubview) {
        router.dismissAll(except: .tools)
        
        switch destination {
        case .colors, .themes: 
            router.toggle(destination)
        case .generate:
            tappedGenerateImage()
        case .tools:
            break
        }
    }
    
    private func tappedGenerateImage() {
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
