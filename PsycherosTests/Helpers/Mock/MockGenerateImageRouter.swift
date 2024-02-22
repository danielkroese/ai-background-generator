import Combine

final class MockGenerateImageRouter: GenerateImageRouting {
    private(set) var calledToggleCount = 0
    private(set) var calledPresentCount = 0
    private(set) var calledDismissCount = 0
    private(set) var calledTappedBackgroundCount = 0
    private(set) var calledIsPresentingCount = 0
    
    var isPresentingReturnValue = false
    
    var subject = PassthroughSubject<Set<GenerateImageElement>, Never>()
    
    var publisher: AnyPublisher<Set<GenerateImageElement>, Never> {
        subject.eraseToAnyPublisher()
    }
    
    func toggle(_ element: GenerateImageElement) {
        calledToggleCount += 1
    }
    
    func present(_ element: GenerateImageElement) {
        calledPresentCount += 1
    }
    
    func dismiss(_ element: GenerateImageElement) {
        calledDismissCount += 1
    }
    
    func tappedBackground() {
        calledTappedBackgroundCount += 1
    }
    
    func isPresenting(_ element: GenerateImageElement) -> Bool {
        calledIsPresentingCount += 1
        
        return isPresentingReturnValue
    }
}
