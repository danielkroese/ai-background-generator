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
        presentedElements.toggle(element)
    }
    
    func present(_ element: GenerateImageElement) {
        presentedElements.insert(element)
    }
    
    func dismiss(_ element: GenerateImageElement) {
        presentedElements.remove(element)
    }
    
    func dismissAll(except element: GenerateImageElement? = nil) {
        presentedElements = presentedElements.filter { $0 == element}
    }
    
    func isPresenting(_ element: GenerateImageElement) -> Bool {
        presentedElements.contains(element)
    }
}
