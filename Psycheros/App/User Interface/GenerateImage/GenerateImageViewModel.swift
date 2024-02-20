import Foundation
import SwiftUI
import Combine

@MainActor
final class GenerateImageViewModel: ObservableObject {
    @Published var currentSubviews: Set<GenerateImageElement> = []
    @Published var selectedThemes: Set<Theme> = [.cyberpunk, .space]
    @Published var selectedColor: AllowedColor = .blue
    @Published var messageModel: MessageModel?
    
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var generatedImage: UIImage?
    
    private(set) var imageTask: Task<(), Never>?
    
    private var subscriptions = Set<AnyCancellable>()
    
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
        
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        router.publisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$currentSubviews)
        
        $selectedColor
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.didSelectColor()
            }
            .store(in: &subscriptions)
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
            setMessage(
                title: "Something went wrong",
                message: "A theme has to be selected."
            )
            
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
                setMessage(
                    title: "Something went wrong",
                    message: "No image to save"
                )
                
                return
            }
            
            do {
                try await imageSaver.saveToPhotoAlbum(image: generatedImage)
                
                setMessage(
                    title: "Success!",
                    message: "Image saved to your gallery."
                )
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
        isLoading = value
    }
    
    private func setImage(from image: UIImage) {
        generatedImage = image
    }
    
    private func setError(_ error: Error?) {
        guard let error else {
            messageModel = nil
            return
        }
        
        let errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        
        setMessage(
            title: "Something went wrong",
            message: errorMessage
        )
    }
    
    private func setMessage(title: String, message: String) {
        messageModel = MessageModel(title: title, message: message)
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
