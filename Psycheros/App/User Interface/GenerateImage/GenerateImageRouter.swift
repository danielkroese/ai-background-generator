import Combine

protocol GenerateImageRouting {
    var publisher: AnyPublisher<Set<GenerateImageElement>, Never> { get }
    
    func toggle(_ element: GenerateImageElement)
    func present(_ element: GenerateImageElement)
    func dismiss(_ element: GenerateImageElement)
    func dismissAll(except element: GenerateImageElement?)
    func tappedBackground()
    func isPresenting(_ element: GenerateImageElement) -> Bool
}

enum GenerateImageElement {
    case tools, colors, themes, generate, save, share
}

final class GenerateImageRouter: GenerateImageRouting {
    var publisher: AnyPublisher<Set<GenerateImageElement>, Never> {
        $presentedElements.eraseToAnyPublisher()
    }
    
    @Published private var presentedElements: Set<GenerateImageElement>
    
    init(presentedElements: Set<GenerateImageElement> = []) {
        self.presentedElements = presentedElements
    }
    
    func toggle(_ element: GenerateImageElement) {
        if presentedElements.contains(element) {
            dismiss(element)
        } else {
            present(element)
        }
    }
    
    func present(_ element: GenerateImageElement) {
        var elements = presentedElements.filter { $0 == .tools }
        
        elements.insert(element)
        
        set(elements)
    }
    
    func dismiss(_ element: GenerateImageElement) {
        set(presentedElements.filter { $0 != element} )
    }
    
    func dismissAll(except element: GenerateImageElement? = nil) {
        set(presentedElements.filter { $0 == element} )
    }
    
    func tappedBackground() {
        if presentedElements.contains(.tools) {
            dismissAll()
        } else {
            present(.tools)
        }
    }
    
    func isPresenting(_ element: GenerateImageElement) -> Bool {
        presentedElements.contains(element)
    }
    
    private func set(_ presentedElements: Set<GenerateImageElement>) {
        self.presentedElements = presentedElements
    }
}
