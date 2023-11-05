import Foundation

struct ImagePrompt: Equatable {
    let color: String
    let feelings: [Feeling]
    
    var isEmpty: Bool {
        color.isEmpty || feelings.isEmpty
    }
}
