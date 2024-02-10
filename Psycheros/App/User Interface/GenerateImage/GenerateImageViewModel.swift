import Foundation
import SwiftUI
import Combine

@MainActor
protocol GenerateImageViewModeling: ObservableObject {
    var selectedColor: AllowedColor { get set }
    var selectedThemes: Set<Theme> { get set }
    var currentSubviews: Set<GenerateImageElement>{ get set }
    
    var isLoading: Bool { get }
    var messageText: String? { get }
    var generatedImage: UIImage? { get }
    
    func onAppear()
    func isPresenting(_ element: GenerateImageElement) -> Bool
    func tapped(on destination: GenerateImageElement)
    func tappedBackground()
}

@MainActor
final class GenerateImageViewModel: GenerateImageViewModeling {
    @Published var currentSubviews: Set<GenerateImageElement> = []
    @Published var selectedThemes: Set<Theme> = [.cyberpunk, .space]
    @Published var selectedColor: AllowedColor = .blue { didSet { didSelectColor() } }
    
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var messageText: String?
    @Published private(set) var generatedImage: UIImage?
    
    private(set) var imageTask: Task<(), Never>?
    
    private let imageGenerator: ImageGenerating
    private let imageSaver: ImageSaving
    private let router: GenerateImageRouting
    
    init(
        imageGenerator: ImageGenerating = ImageGenerator(),
        imageSaver: ImageSaving = ImageSaver(),
        router: GenerateImageRouting = GenerateImageRouter()
    ) {
        self.imageGenerator = imageGenerator
        self.imageSaver = imageSaver
        self.router = router
        
        router.publisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$currentSubviews)
    }
    
    deinit {
        imageTask?.cancel()
    }
    
    func onAppear() {
        router.present(.tools)
    }
    
    func isPresenting(_ element: GenerateImageElement) -> Bool {
        currentSubviews.contains(element)
    }
    
    func tappedBackground() {
        if isLoading == false {
            router.tappedBackground()
        }
    }
    
    func tapped(on destination: GenerateImageElement) {        
        switch destination {
        case .colors, .themes:
            router.toggle(destination)
        case .generate:
            router.dismissAll(except: .tools)
            tappedGenerateImage()
        case .save:
            router.dismissAll(except: .tools)
            tappedSaveImage()
        case .tools:
            break
        }
    }
    
    private func tappedGenerateImage() {
        guard isLoading == false else {
            return
        }
        
        guard selectedThemes.isEmpty == false else {
            messageText = "Theme required"
            return
        }
        
        setLoading(true)
        setError(nil)
        
        generateImage(from: imageQuery)
    }
    
    private func tappedSaveImage() {
        setLoading(true)
        setError(nil)
        
        imageTask = Task {
            defer {
                setLoading(false)
            }
            
            guard let generatedImage else {
                messageText = "No image to save"
                return
            }
            
            do {
                try await imageSaver.saveToPhotoAlbum(image: generatedImage)
                
                messageText = "Image saved to your gallery"
            } catch {
                setError(error)
            }
        }
    }
    
    private func didSelectColor() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.router.dismiss(.colors)
        }
    }
    
    private func setLoading(_ value: Bool) {
        Task { @MainActor in
            isLoading = value
        }
    }
    
    private func setImage(from image: UIImage) {
        Task { @MainActor in
            generatedImage = image
        }
    }
    
    private func setError(_ error: Error?) {
        Task { @MainActor in
            guard let error else {
                messageText = nil
                return
            }
            
            messageText = (error as? ImageGeneratingError)?.rawValue ?? error.localizedDescription
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
