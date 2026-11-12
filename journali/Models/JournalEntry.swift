import Foundation

struct JournalEntry: Identifiable, Codable {
    var id = UUID()
    var title: String
    var date: Date
    var body: String
    var isBookmarked: Bool = false
}

extension JournalEntry {
    static let samples: [JournalEntry] = [
        JournalEntry(title: "My Birthday", date: .now,
                     body: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio.",
                     isBookmarked: false),
        JournalEntry(title: "Today's Journal", date: .now,
                     body: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio."),
        JournalEntry(title: "Great Day", date: .now,
                     body: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio.")
    ]
}
