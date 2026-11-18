import SwiftUI
import SwiftData
import Combine

class JournalViewModel: ObservableObject {

    var context: ModelContext!

    @Published var entries: [JournalEntry] = []

    func fetch() {
        entries = (try? context.fetch(FetchDescriptor<JournalEntry>())) ?? []
    }

    func add(title: String, body: String) {
        context.insert(JournalEntry(title: title, body: body))
        fetch()
    }

    func update(_ entry: JournalEntry, title: String, body: String) {
        entry.title = title
        entry.body = body
        fetch()
    }

    func delete(_ entry: JournalEntry) {
        context.delete(entry)
        fetch()
    }

    func toggleBookmark(_ entry: JournalEntry) {
        entry.isBookmarked.toggle()
        fetch()
    }
}
