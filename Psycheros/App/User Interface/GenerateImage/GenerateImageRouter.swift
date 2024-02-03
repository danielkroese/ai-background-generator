import Combine

protocol GenerateImageRouting {
    var publisher: AnyPublisher<Set<GenerateImageElement>, Never> { get }
    
    func toggle(_ element: GenerateImageElement)
    func present(_ element: GenerateImageElement)
    func dismiss(_ element: GenerateImageElement)
    func dismissAll(except element: GenerateImageElement?)
    func isPresenting(_ element: GenerateImageElement) -> Bool
}

extension GenerateImageRouting {
    func dismissAll(except element: GenerateImageElement? = nil) {
        dismissAll(except: element)
    }
}

enum GenerateImageElement {
    case tools, colors, themes, generate, save
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
    
    func isPresenting(_ element: GenerateImageElement) -> Bool {
        presentedElements.contains(element)
    }
    
    private func set(_ presentedElements: Set<GenerateImageElement>) {
        self.presentedElements = presentedElements
    }
}
