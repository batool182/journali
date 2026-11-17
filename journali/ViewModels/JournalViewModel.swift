import SwiftUI
import Combine

class JournalViewModel: ObservableObject {

    // مفتاح الحفظ
    private let saveKey = "savedEntries"

    // كل ما تتغير القائمة نحفظها تلقائياً
    @Published var entries: [JournalEntry] = [] {
        didSet {
            save()
        }
    }

    // أول ما ينشأ الـ ViewModel نحمّل اليوميات المحفوظة
    init() {
        load()
    }

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

    // تحويل القائمة إلى JSON وحفظها
    private func save() {
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    // قراءة JSON المحفوظ وتحويله إلى قائمة
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: saveKey),
              let saved = try? JSONDecoder().decode([JournalEntry].self, from: data) else {
            return
        }
        entries = saved
    }
}
