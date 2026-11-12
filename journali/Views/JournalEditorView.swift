import SwiftUI

struct JournalEditorView: View {

    // نستخدمه لقفل الشاشة
    @Environment(\.dismiss) private var dismiss

    // العنوان والنص اللي يكتبهم المستخدم
    @State private var title: String
    @State private var bodyText: String

    // هل نعرض رسالة الإلغاء؟
    @State private var showDiscardDialog = false

    // القيم الأصلية، نقارن فيها لنعرف لو صار تغيير
    private let originalTitle: String
    private let originalBody: String

    // الكود اللي ينفذ لما يضغط المستخدم زر الحفظ
    var onSave: (String, String) -> Void

    // نستقبل العنوان والنص الأصلي (فاضيين لو يومية جديدة)
    init(title: String = "", body: String = "", onSave: @escaping (String, String) -> Void) {
        _title = State(initialValue: title)
        _bodyText = State(initialValue: body)
        originalTitle = title
        originalBody = body
        self.onSave = onSave
    }

    // هل المستخدم غيّر شيء؟
    private var hasChanges: Bool {
        if title != originalTitle {
            return true
        }
        if bodyText != originalBody {
            return true
        }
        return false
    }

    var body: some View {
        ZStack {
            Color.cardBackground.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                topButtons

                TextField("Title", text: $title)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(Color.primaryText)

                Text(Date.now, format: .dateTime.day(.twoDigits).month(.twoDigits).year())
                    .font(.system(size: 16))
                    .foregroundStyle(Color.secondaryText)

                TextEditor(text: $bodyText)
                    .font(.system(size: 20))
                    .foregroundStyle(Color.primaryText)
                    .scrollContentBackground(.hidden)

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        // يمنع إغلاق الشاشة بالسحب لو في تغييرات
        .interactiveDismissDisabled(hasChanges)
    }

    private var topButtons: some View {
        HStack {
            // زر الإغلاق X
            Button {
                if hasChanges {
                    // في تغييرات: نسأل المستخدم
                    showDiscardDialog = true
                } else {
                    // ما في تغييرات: نقفل مباشرة
                    dismiss()
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color.primaryText)
                    .frame(width: 44, height: 44)
                    .background(Color.appBackground, in: Circle())
            }
            // الرسالة تظهر ملتصقة بزر X
            .confirmationDialog(
                "Are you sure you want to discard changes on this journal?",
                isPresented: $showDiscardDialog,
                titleVisibility: .visible
            ) {
                Button("Discard Changes", role: .destructive) {
                    dismiss()
                }
                Button("Keep Editing", role: .cancel) { }
            }

            Spacer()

            // زر الحفظ ✓
            Button {
                onSave(title, bodyText)
                dismiss()
            } label: {
                Image(systemName: "checkmark")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color.appBackground)
                    .frame(width: 44, height: 44)
                    .background(Color.primaryAccent, in: Circle())
            }
        }
    }
}

#Preview {
    JournalEditorView(onSave: { title, text in
        print(title, text)
    })
}
