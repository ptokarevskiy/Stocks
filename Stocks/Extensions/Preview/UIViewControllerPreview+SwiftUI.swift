#if canImport(SwiftUI) && DEBUG
    import SwiftUI
    struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
        let viewController: ViewController

        init(_ builder: @escaping () -> ViewController) {
            viewController = builder()
        }

        // MARK: - UIViewControllerRepresentable

        func makeUIViewController(context _: Context) -> ViewController {
            viewController
        }

        func updateUIViewController(_: ViewController,
                                    context _:
                                    UIViewControllerRepresentableContext<UIViewControllerPreview<ViewController>>) {}
    }
#endif

// Thanks to @Mattt https://twitter.com/mattt
// https://nshipster.com/swiftui-previews/
