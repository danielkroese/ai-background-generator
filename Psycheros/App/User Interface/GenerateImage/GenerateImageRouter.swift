import Foundation

protocol GenerateImageRouting: ObservableObject {
    var presentedSubviews: Set<GenerateImageSubview> { get }
    
    func toggle(_ subview: GenerateImageSubview)
    func present(_ subview: GenerateImageSubview)
    func dismiss(_ subview: GenerateImageSubview)
    func dismissAll(except subview: GenerateImageSubview?)
}

extension GenerateImageRouting {
    func dismissAll(except subview: GenerateImageSubview? = nil) {
        dismissAll(except: subview)
    }
}

enum GenerateImageSubview {
    case tools, colors, themes
}

final class GenerateImageRouter: GenerateImageRouting {
    @Published var presentedSubviews: Set<GenerateImageSubview>
    
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
}
