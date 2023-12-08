import Foundation
import SwiftData

@Model
final class BackgroundEntry {
    let timestamp: Date
    var image: String // for now
    var color: String // for now
    @Relationship(deleteRule: .cascade) var themes: [Theme]
    @Relationship(deleteRule: .cascade) var motivationalTexts: [String]
    
    init(
        timestamp: Date = Date(),
        image: String = "",
        color: String = "",
        themes: [Theme] = [],
        motivationalTexts: [String] = []
    ) {
        self.timestamp = timestamp
        self.image = image
        self.color = color
        self.themes = themes
        self.motivationalTexts = motivationalTexts
    }
}

enum Theme: String, Codable, Equatable {
    case space,
         island,
         nature,
         cyberpunk
}
