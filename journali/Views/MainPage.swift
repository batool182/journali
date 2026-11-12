import SwiftUI

// خيارات الترتيب
enum SortOption {
    case bookmark
    case date
}

struct MainPage: View {
    
    @StateObject private var viewModel = JournalViewModel()
    // النص اللي يكتبه المستخدم في البحث
    @State private var searchText = ""
    // الترتيب الحالي (الافتراضي: بالتاريخ)
    @State private var sortOption: SortOption = .date
    // هل شاشة الإضافة ظاهرة؟
    @State private var showEditor = false
    // اليومية اللي يبي المستخدم يعدلها
    @State private var entryToEdit: JournalEntry?
    // اليومية اللي يبي المستخدم يحذفها
    @State private var entryToDelete: JournalEntry?
    // هل نعرض رسالة الحذف؟
    @State private var showDeleteAlert = false
    
    // القائمة اللي تظهر للمستخدم بعد البحث والترتيب
    private var displayedEntries: [JournalEntry] {

        // نبدأ بكل اليوميات
        var result = viewModel.entries

        // أولاً: البحث
        if searchText.isEmpty == false {
            let searchWord = searchText.lowercased()

            result = result.filter { entry in
                let titleMatches = entry.title.lowercased().contains(searchWord)
                let bodyMatches = entry.body.lowercased().contains(searchWord)
                return titleMatches || bodyMatches
            }
        }

        // ثانياً: الترتيب
        if sortOption == .bookmark {
            // البوكمارك أولاً
            result = result.sorted { first, second in
                if first.isBookmarked == true && second.isBookmarked == false {
                    return true
                }
                return false
            }
        } else {
            // الأحدث أولاً
            result = result.sorted { first, second in
                return first.date > second.date
            }
        }

        return result
    }

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            // لو ما في يوميات نعرض الـ Empty State
            if viewModel.entries.isEmpty {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    Spacer()
                    emptyState
                    Spacer()
                }
                .padding(.horizontal, 20)
            } else {
                // لو في يوميات نعرض القائمة
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        header

                        LazyVStack(spacing: 16) {
                            ForEach(displayedEntries) { entry in
                                SwipeableCard(
                                    entry: entry,
                                    onBookmarkTap: {
                                        viewModel.toggleBookmark(entry)
                                    },
                                    onDeleteTap: {
                                        // نحفظ اليومية ونعرض الرسالة
                                        entryToDelete = entry
                                        showDeleteAlert = true
                                    },
                                    onCardTap: {
                                        entryToEdit = entry
                                    }
                                )
                            }
                            // لو البحث ما رجّع نتائج
                            if displayedEntries.isEmpty {
                                Text("No results found")
                                    .font(.system(size: 18))
                                    .foregroundStyle(Color.secondaryText)
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 40)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    // مسافة تحت عشان آخر بطاقة ما تختفي ورا شريط البحث
                    .padding(.bottom, 100)
                }
            }
        }
        // شريط البحث يطفو فوق كل شي في أسفل الشاشة
        .overlay(alignment: .bottom) {
            searchBar
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
        }
        .sheet(isPresented: $showEditor) {
            JournalEditorView { title, text in
                viewModel.add(title: title, body: text)
            }
        }
        .sheet(item: $entryToEdit) { entry in
            JournalEditorView(title: entry.title, body: entry.body) { newTitle, newBody in
                // ننسخ اليومية ونغير العنوان والنص فقط
                var updatedEntry = entry
                updatedEntry.title = newTitle
                updatedEntry.body = newBody
                viewModel.update(updatedEntry)
            }
        }
        .alert("Delete Journal?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {
                entryToDelete = nil
            }
            Button("Delete", role: .destructive) {
                if let entry = entryToDelete {
                    withAnimation {
                        viewModel.delete(entry)
                    }
                }
                entryToDelete = nil
            }
        } message: {
            Text("Are you sure you want to delete this journal?")
        }
    }

    // العنوان والأزرار (نفس المرحلة 1)
    private var header: some View {
        HStack {
            Text("Journal")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(Color.primaryText)

            Spacer()

            HStack(spacing: 20) {
                Button {
                    // الفلتر: نسويه لاحقاً
                } label: {
                    Menu {
                        Button("Sort by Bookmark") {
                            sortOption = .bookmark
                        }

                        Button("Sort by Entry Date") {
                            sortOption = .date
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
                    }
                }

                Button {
                    // نظهر شاشة الإضافة
                    showEditor = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .font(.system(size: 20, weight: .medium))
            .foregroundStyle(Color.primaryText)
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(Color.cardBackground, in: Capsule())
        }
        .padding(.top, 8)
    }

    // شريط البحث
    private var searchBar: some View {
        HStack(spacing: 12) {
            // أيقونة العدسة
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.secondaryText)

            // خانة الكتابة، مربوطة بالمتغير searchText
            TextField("Search", text: $searchText)
                .foregroundStyle(Color.primaryText)

            // أيقونة المايك
            Image(systemName: "mic")
                .foregroundStyle(Color.secondaryText)
        }
        .font(.system(size: 18))
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.cardBackground, in: Capsule())
    }

    // شاشة "ما في يوميات"
    private var emptyState: some View {
        VStack(spacing: 12) {
            Text("Begin Your Journal")
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(Color.accentPurple)

            Text("Craft your personal diary, tap the plus icon to begin")
                .font(.system(size: 18))
                .foregroundStyle(Color.primaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    MainPage()
}
