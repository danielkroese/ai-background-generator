import Combine

protocol GenerateImageRouting {
    var publisher: AnyPublisher<Set<GenerateImageDestination>, Never> { get }
    
    func toggle(_ subview: GenerateImageDestination)
    func present(_ subview: GenerateImageDestination)
    func dismiss(_ subview: GenerateImageDestination)
    func dismissAll(except subview: GenerateImageDestination?)
    func isPresenting(_ subview: GenerateImageDestination) -> Bool
}

extension GenerateImageRouting {
    func dismissAll(except subview: GenerateImageDestination? = nil) {
        dismissAll(except: subview)
    }
}

enum GenerateImageDestination {
    case tools, colors, themes, generate, save
}

final class GenerateImageRouter: GenerateImageRouting {
    var publisher: AnyPublisher<Set<GenerateImageDestination>, Never> {
        $presentedSubviews.eraseToAnyPublisher()
    }
    
    @Published private var presentedSubviews: Set<GenerateImageDestination>
    
    init(presentedSubviews: Set<GenerateImageDestination> = []) {
        self.presentedSubviews = presentedSubviews
    }
    
    func toggle(_ subview: GenerateImageDestination) {
        presentedSubviews.toggle(subview)
    }
    
    func present(_ subview: GenerateImageDestination) {
        presentedSubviews.insert(subview)
    }
    
    func dismiss(_ subview: GenerateImageDestination) {
        presentedSubviews.remove(subview)
    }
    
    func dismissAll(except subview: GenerateImageDestination? = nil) {
        presentedSubviews = presentedSubviews.filter { $0 == subview}
    }
    
    func isPresenting(_ subview: GenerateImageDestination) -> Bool {
        presentedSubviews.contains(subview)
    }
}
