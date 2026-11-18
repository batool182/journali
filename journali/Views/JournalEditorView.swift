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
    private let date: Date

    // الكود اللي ينفذ لما يضغط المستخدم زر الحفظ
    var onSave: (String, String) -> Void

    // نستقبل العنوان والنص الأصلي (فاضيين لو يومية جديدة)
    init(title: String = "", body: String = "", date: Date = .now, onSave: @escaping (String, String) -> Void) {
        _title = State(initialValue: title)
        _bodyText = State(initialValue: body)
        originalTitle = title
        originalBody = body
        self.date = date
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
    // هل كتب المستخدم شي؟
    private var canSave: Bool {
        title.isEmpty == false || bodyText.isEmpty == false
    }

    var body: some View {
        ZStack {
            Color.cardBackground.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                topButtons

                TextField("Title", text: $title)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(Color.primaryText)

                Text(date, format: .dateTime.day(.twoDigits).month(.twoDigits).year())
                    .font(.system(size: 16))
                    .foregroundStyle(Color.secondaryText)

                TextEditor(text: $bodyText)
                    .font(.system(size: 20))
                    .foregroundStyle(Color.primaryText)
                    .scrollContentBackground(.hidden)
                    .overlay(alignment: .topLeading) {
                        if bodyText.isEmpty {
                            Text("Type your Journal...")
                                .font(.system(size: 20))
                                .foregroundStyle(Color.secondaryText.opacity(0.6))
                                .padding(.top, 8)
                                .padding(.leading, 5)
                                .allowsHitTesting(false)
                        }
                    }

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
                    showDiscardDialog = true
                } else {
                    dismiss()
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color.primaryText)
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.glass)
            .buttonBorderShape(.circle)
            .popover(isPresented: $showDiscardDialog, arrowEdge: .top) {
                discardCard
                    .presentationCompactAdaptation(.popover)
                    .presentationBackground(Color(white: 0.09))
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
            }
            .buttonStyle(.glassProminent)
            .buttonBorderShape(.circle)
            .tint(Color.primaryAccent)
            .buttonStyle(.glassProminent)
            .buttonBorderShape(.circle)
            .tint(Color.primaryAccent)
            .disabled(canSave == false)
        }
    }

    // كرت التأكيد اللي يظهر لما تضغط X
    private var discardCard: some View {
        VStack(spacing: 14) {
            Text("Are you sure you want to discard changes on this journal?")
                .font(.system(size: 18))
                .foregroundStyle(Color.secondaryText)
                .frame(maxWidth: .infinity, alignment: .leading)

            Button {
                showDiscardDialog = false
                dismiss()
            } label: {
                Text("Discard Changes")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
            }
            .buttonStyle(.glass)
            .buttonBorderShape(.capsule)

            Button {
                showDiscardDialog = false
            } label: {
                Text("Keep Editing")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(Color.primaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
            }
            .buttonStyle(.glass)
            .buttonBorderShape(.capsule)
        }
        .padding(24)
        .frame(width: 320)
    }
}

#Preview {
    JournalEditorView(onSave: { title, text in
        print(title, text)
    })
}
