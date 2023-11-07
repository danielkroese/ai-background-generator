import Foundation

protocol StabilityAIConnecting {
    var isRunning: Bool { get }
    
    func setup() throws
}

enum StabilityAIConnectingError: Error {
    case alreadySetup
}

final class StabilityAIConnection: StabilityAIConnecting {
    private(set) var isRunning = false
    
    func setup() throws {
        guard isRunning == false else {
            throw StabilityAIConnectingError.alreadySetup
        }
        
        isRunning = true
    }
}
