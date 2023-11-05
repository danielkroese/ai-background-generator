import Foundation
import SwiftData

@Model
final class JournalEntry {
    var timestamp: Date
    
    init(timestamp: Date = Date()) {
        self.timestamp = timestamp
    }
}
