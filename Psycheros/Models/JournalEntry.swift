import Foundation
import SwiftData

@Model
final class JournalEntry {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
