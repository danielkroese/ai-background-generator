import Combine

protocol GenerateImageRouting {
    var publisher: AnyPublisher<Set<GenerateImageSubview>, Never> { get }
    
    func toggle(_ subview: GenerateImageSubview)
    func present(_ subview: GenerateImageSubview)
    func dismiss(_ subview: GenerateImageSubview)
    func dismissAll(except subview: GenerateImageSubview?)
    func isPresenting(_ subview: GenerateImageSubview) -> Bool
}

extension GenerateImageRouting {
    func dismissAll(except subview: GenerateImageSubview? = nil) {
        dismissAll(except: subview)
    }
}

enum GenerateImageSubview { // Rename to GenerateImageDestination?
    case tools, colors, themes, generate, save
}

final class GenerateImageRouter: GenerateImageRouting {
    var publisher: AnyPublisher<Set<GenerateImageSubview>, Never> {
        $presentedSubviews.eraseToAnyPublisher()
    }
    
    @Published private var presentedSubviews: Set<GenerateImageSubview>
    
    init(presentedSubviews: Set<GenerateImageSubview> = []) {
        self.presentedSubviews = presentedSubviews
    }
    
    func toggle(_ subview: GenerateImageSubview) {
        presentedSubviews.toggle(subview)
    }
    
    func present(_ subview: GenerateImageSubview) {
        presentedSubviews.insert(subview)
    }
    
    func dismiss(_ subview: GenerateImageSubview) {
        presentedSubviews.remove(subview)
    }
    
    func dismissAll(except subview: GenerateImageSubview? = nil) {
        presentedSubviews = presentedSubviews.filter { $0 == subview}
    }
    
    func isPresenting(_ subview: GenerateImageSubview) -> Bool {
        presentedSubviews.contains(subview)
    }
}
