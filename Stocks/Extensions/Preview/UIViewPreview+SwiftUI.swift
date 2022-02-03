#if canImport(SwiftUI) && DEBUG
    import SwiftUI
    struct UIViewPreview<View: UIView>: UIViewRepresentable {
        let view: View

        init(_ builder: @escaping () -> View) {
            view = builder()
        }

        // MARK: - UIViewRepresentable

        func makeUIView(context _: Context) -> UIView {
            view
        }

        func updateUIView(_ view: UIView, context _: Context) {
            view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        }
    }
#endif

// Thanks to Matt
// https://nshipster.com/swiftui-previews/
