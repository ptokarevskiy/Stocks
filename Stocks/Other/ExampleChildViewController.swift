import UIKit

// MARK: - PanelViewController

class PanelViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .secondarySystemBackground

        let grabberView = UIView(frame: .init(x: 0, y: 0, width: 100, height: 10))
        grabberView.backgroundColor = .label
        grabberView.center = .init(x: view.center.x, y: 5)
        view.addSubview(grabberView)
    }
}

// On main view:
// func setUpChildView() {
//    let panelViewController  = PanelViewController()
//
//    addChild(panelViewController)
//    view.addSubview(panelViewController.view)
//    panelViewController.didMove(toParent: self)
//    panelViewController.view.frame = .init(x: 0, y: view.height / 2, width: view.width, height: view.height)
//
// }

#if canImport(SwiftUI) && DEBUG
    import SwiftUI

    @available(iOS 14.0, *)
    struct PanelViewController_Preview: PreviewProvider {
        static var previews: some View {
            Group {
                UIViewControllerPreview {
                    UINavigationController(rootViewController: WatchListViewController())
                }.previewLayout(.sizeThatFits)
                    .environment(\.colorScheme, .light)
                    .ignoresSafeArea(.all)
                    .previewDeviceWithName(.iPhone12Pro)

                UIViewControllerPreview {
                    UINavigationController(rootViewController: WatchListViewController())
                }.previewLayout(.sizeThatFits)
                    .environment(\.colorScheme, .dark)
                    .ignoresSafeArea(.all)
                    .previewDeviceWithName(.iPhone12Pro)
            }
        }
    }
#endif
