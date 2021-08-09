import UIKit

// MARK: - StockDetailsViewController

class StockDetailsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
    }
}

#if canImport(SwiftUI) && DEBUG
    import SwiftUI

    @available(iOS 14.0, *)
    struct StockDetailsViewController_Preview: PreviewProvider {
        static var previews: some View {
            UIViewControllerPreview {
                UINavigationController(rootViewController: StockDetailsViewController())
            }
            .previewLayout(.sizeThatFits)
            .environment(\.colorScheme, .light)
            .ignoresSafeArea(.all)
            .previewDeviceWithName(.iPhone12Pro)
        }
    }
#endif
