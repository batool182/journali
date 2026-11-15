import SwiftUI

struct SwipeableCard: View {

    // اليومية اللي نعرضها
    let entry: JournalEntry

    // الكود اللي ينفذ لما يضغط المستخدم البوكمارك
    var onBookmarkTap: () -> Void

    // الكود اللي ينفذ لما يضغط المستخدم زر الحذف
    var onDeleteTap: () -> Void

    // الكود اللي ينفذ لما يضغط المستخدم على البطاقة
    var onCardTap: () -> Void

    // كم زحزحنا البطاقة لليسار (0 = مكانها الأصلي)
    @State private var offsetX: CGFloat = 0

    // عرض المساحة اللي ينكشف فيها زر الحذف
    private let revealWidth: CGFloat = 100

    var body: some View {
        ZStack(alignment: .trailing) {

            // الطبقة السفلية: زر الحذف
            deleteButton

            // الطبقة العلوية: البطاقة
            JournalCard(entry: entry, onBookmarkTap: onBookmarkTap)
                .offset(x: offsetX)
                .onTapGesture {
                    if offsetX == 0 {
                        // البطاقة في مكانها: نفتح التعديل
                        onCardTap()
                    } else {
                        // البطاقة مفتوحة: نرجعها لمكانها
                        closeCard()
                    }
                }
                .gesture(dragGesture)
        }
    }

    // زر الحذف الأحمر
    private var deleteButton: some View {
        Button {
            onDeleteTap()
        } label: {
            Image(systemName: "trash.fill")
                .font(.system(size: 22))
                .foregroundStyle(Color.primaryText)
                .frame(width: 70, height: 48)
                .background(Color.deleteRed, in: Capsule())
        }
        .padding(.trailing, 12)
    }

    // حركة السحب
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 20)
            .onChanged { value in
                // مقدار حركة الإصبع أفقياً
                let movement = value.translation.width

                if movement < 0 {
                    // سحب لليسار: نحرك البطاقة، بدون ما نتجاوز عرض الزر
                    offsetX = max(movement, -revealWidth)
                }
            }
            .onEnded { value in
                // لما يرفع إصبعه نقرر: نفتح أو نرجع
                let movement = value.translation.width

                if movement < -50 {
                    openCard()
                } else {
                    closeCard()
                }
            }
    }

    // نفتح البطاقة ونكشف زر الحذف
    private func openCard() {
        withAnimation(.spring()) {
            offsetX = -revealWidth
        }
    }

    // نرجع البطاقة لمكانها
    func closeCard() {
        withAnimation(.spring()) {
            offsetX = 0
        }
    }
}


