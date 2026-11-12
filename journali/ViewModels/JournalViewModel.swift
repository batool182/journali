import SwiftUI
import Combine


class JournalViewModel: ObservableObject {
    @Published var entries: [JournalEntry] = JournalEntry.samples

    func add(title: String, body: String) {
        let newEntry = JournalEntry(title: title, date: .now, body: body)
        entries.insert(newEntry, at: 0)
    }

    func update(_ entry: JournalEntry) {
        guard let index = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[index] = entry
    }

    func delete(_ entry: JournalEntry) {
        entries.removeAll { $0.id == entry.id }
    }

    func toggleBookmark(_ entry: JournalEntry) {
        guard let index = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[index].isBookmarked.toggle()
    }
}
