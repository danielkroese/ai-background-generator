import Foundation

protocol GenerateImageRouting: ObservableObject {
    var presentedSubviews: Set<GenerateImageSubview> { get }
    
    func toggleToolbar()
    func present(_ subview: GenerateImageSubview)
}

enum GenerateImageSubview {
    case tools, colors, themes
}

final class GenerateImageRouter: GenerateImageRouting {
    var presentedSubviews: Set<GenerateImageSubview>
    
    init(presentedSubviews: Set<GenerateImageSubview> = []) {
        self.presentedSubviews = presentedSubviews
    }
    
    func toggleToolbar() {
        presentedSubviews.toggle(.tools)
    }
    
    func present(_ subview: GenerateImageSubview) {
        
    }
}
