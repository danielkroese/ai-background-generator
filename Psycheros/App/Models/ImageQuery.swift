import Foundation

struct ImageQuery: Equatable {
    var color: String
    var themes: Set<Theme>
    var size: ImageRequestModel.ImageSize
    
    var isEmpty: Bool {
        color.isEmpty || themes.isEmpty
    }
    
    var isNotEmpty: Bool {
        isEmpty == false
    }
}
