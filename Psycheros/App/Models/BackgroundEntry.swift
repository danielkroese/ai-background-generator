import Foundation

final class BackgroundEntry {
    let timestamp: Date
    var image: String // for now
    var color: String // for now
    var themes: [Theme]
    var motivationalTexts: [String]
    
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
