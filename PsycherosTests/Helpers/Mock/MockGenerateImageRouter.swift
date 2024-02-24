import Combine

final class MockGenerateImageRouter: GenerateImageRouting {
    private(set) var calledToggleCount = 0
    private(set) var calledToggleElement: GenerateImageElement?
    private(set) var calledPresentCount = 0
    private(set) var calledPresentElement: GenerateImageElement?
    private(set) var calledDismissCount = 0
    private(set) var calledDismissElement: GenerateImageElement?
    private(set) var calledDismissAllCount = 0
    private(set) var calledDismissAllExceptElement: GenerateImageElement?
    private(set) var calledTappedBackgroundCount = 0
    private(set) var calledIsPresentingCount = 0
    private(set) var calledIsPresentingElement: GenerateImageElement?
    
    var isPresentingReturnValue = false
    
    var subject = PassthroughSubject<Set<GenerateImageElement>, Never>()
    
    var publisher: AnyPublisher<Set<GenerateImageElement>, Never> {
        subject.eraseToAnyPublisher()
    }
    
    func toggle(_ element: GenerateImageElement) {
        calledToggleCount += 1
        calledToggleElement = element
    }
    
    func present(_ element: GenerateImageElement) {
        calledPresentCount += 1
        calledPresentElement = element
    }
    
    func dismiss(_ element: GenerateImageElement) {
        calledDismissCount += 1
        calledDismissElement = element
    }
    
    func dismissAll(except element: GenerateImageElement?) {
        calledDismissAllCount += 1
        calledDismissAllExceptElement = element
    }
    
    func tappedBackground() {
        calledTappedBackgroundCount += 1
    }
    
    func isPresenting(_ element: GenerateImageElement) -> Bool {
        calledIsPresentingCount += 1
        calledIsPresentingElement = element
        
        return isPresentingReturnValue
    }
}
