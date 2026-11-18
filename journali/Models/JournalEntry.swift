import Foundation
import SwiftData

@Model
class JournalEntry {
    var id = UUID()
    var title: String
    var date: Date
    var body: String
    var isBookmarked: Bool

    init(title: String, date: Date = .now, body: String, isBookmarked: Bool = false) {
        self.title = title
        self.date = date
        self.body = body
        self.isBookmarked = isBookmarked
    }
}


