import Foundation

struct ImageQuery: Equatable {
    let color: String
    let themes: [Theme]
    
    var isEmpty: Bool {
        color.isEmpty || themes.isEmpty
    }
    
    var isNotEmpty: Bool {
        isEmpty == false
    }
}
