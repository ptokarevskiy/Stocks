import UIKit

// MARK: - WatchListViewController

class WatchListViewController: UIViewController {
    private var searchTimer: Timer?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        setUpSearchController()
        setUpTitleView()
    }

    // MARK: - Private

    private func setUpSearchController() {
        let resultsViewController = SearchResultsViewController()
        let searchViewController = UISearchController(searchResultsController: resultsViewController)

        resultsViewController.delegate = self
        searchViewController.searchResultsUpdater = self
        navigationItem.searchController = searchViewController
    }

    private func setUpTitleView() {
        let titleView: UIView = .init(frame: .init(x: 0,
                                                   y: 0,
                                                   width: view.width,
                                                   height: navigationController?.navigationBar.height ?? 100))
        let label = UILabel(frame: .init(x: 10, y: 0, width: titleView.width - 20, height: titleView.height))
        label.text = "Stocks"
        label.font = .systemFont(ofSize: 38, weight: .bold)
        titleView.addSubview(label)
        navigationItem.titleView = titleView
    }
}

// MARK: UISearchResultsUpdating

extension WatchListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultsViewController = searchController.searchResultsController as? SearchResultsViewController,
              let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }

        searchTimer?.invalidate()

        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { _ in
            APICaller.shared.search(query: query) { result in
                switch result {
                case let .success(response):
                    DispatchQueue.main.async {
                        resultsViewController.update(withResults: response.result)
                    }

                case let .failure(error):
                    DispatchQueue.main.async {
                        resultsViewController.update(withResults: [])
                    }

                    print(error.localizedDescription)
                }
            }
        })
    }
}

// MARK: SearchResultsViewControllerDelegate

extension WatchListViewController: SearchResultsViewControllerDelegate {
    func searchResultsViewControllerDidSelect(searchResult: SearchResult) {
        print("Did select \(searchResult.displaySymbol)")
    }
}

#if canImport(SwiftUI) && DEBUG
    import SwiftUI

    @available(iOS 14.0, *)
    struct WatchListViewController_Preview: PreviewProvider {
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
