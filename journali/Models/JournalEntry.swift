import Foundation

struct JournalEntry: Identifiable, Codable {
    var id = UUID()
    var title: String
    var date: Date
    var body: String
    var isBookmarked: Bool = false
}


