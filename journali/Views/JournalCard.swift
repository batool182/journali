import SwiftUI

struct JournalCard: View {
    let entry: JournalEntry
    var onBookmarkTap: () -> Void = {}

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.title)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(Color.accentPurple)

                    Text(entry.date, format: .dateTime.day(.twoDigits).month(.twoDigits).year())
                        .font(.system(size: 14))
                        .foregroundStyle(Color.secondaryText)
                }

                Spacer()

                Button(action: onBookmarkTap) {
                    Image(systemName: entry.isBookmarked ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 24))
                        .foregroundStyle(Color.accentPurple)
                }
                .buttonStyle(.plain)
            }

            Text(entry.body)
                .font(.system(size: 18))
                .foregroundStyle(Color.primaryText)
                .lineLimit(4)
                .multilineTextAlignment(.leading)
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 32))
    }
}

#Preview {
    ZStack {
        Color.appBackground.ignoresSafeArea()
        JournalCard(entry: JournalEntry.samples[0])
            .padding(.horizontal, 20)
    }
}
