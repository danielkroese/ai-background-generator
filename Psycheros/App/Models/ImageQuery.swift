import Foundation

struct ImageQuery: Equatable {
    let color: String
    let feelings: [Feeling]
    
    var isEmpty: Bool {
        color.isEmpty || feelings.isEmpty
    }
    
    var isNotEmpty: Bool {
        isEmpty == false
    }
}
