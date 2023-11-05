import Foundation
import SwiftData

@Model
final class JournalEntry {
    let timestamp: Date
    var image: String // for now
    var color: String // for now
    @Relationship(deleteRule: .cascade) var feelings: [Feeling]
    @Relationship(deleteRule: .cascade) var motivationalTexts: [String]
    
    init(
        timestamp: Date = Date(),
        image: String = "",
        color: String = "",
        feelings: [Feeling] = [],
        motivationalTexts: [String] = []
    ) {
        self.timestamp = timestamp
        self.image = image
        self.color = color
        self.feelings = feelings
        self.motivationalTexts = motivationalTexts
    }
}

enum Feeling: String, Codable, Equatable {
    case happy,
         sad,
         anxious,
         grateful,
         moody
}
