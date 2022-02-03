import os.log
import SafariServices
import UIKit

// MARK: - NewsViewController

class NewsViewController: UIViewController {
    enum NewsViewControllerType {
        case topStories
        case company(symbol: String)

        var title: String {
            switch self {
            case .topStories:
                return "Top Stories"

            case let .company(symbol: symbol):
                return symbol.uppercased()
            }
        }
    }

    let tableView: UITableView = .init()

    private let type: NewsViewControllerType
    private var stories = [NewsStory]()

    init(type: NewsViewControllerType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
        fetchNews()
    }

    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }

    // MARK: - Private

    private func setUpTableView() {
        tableView.register(NewsHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: NewsHeaderView.identifier)
        tableView.register(NewsStoryTableViewCell.self,
                           forCellReuseIdentifier: NewsStoryTableViewCell.identifier)
        tableView.backgroundColor = .clear
        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self
    }

    private func fetchNews() {
        APIManager.shared.news(for: .topStories) { [weak self] result in
            switch result {
            case let .success(stories):
                DispatchQueue.main.async {
                    self?.stories = stories
                    self?.tableView.reloadData()
                }

            case let .failure(error):
                os_log(.error, "Unable to fetch news with reason: '%{public}@'", error.localizedDescription)
            }
        }
    }

    private func open(url: URL) {
        let viewController = SFSafariViewController(url: url)

        present(viewController, animated: true)
    }

    private func presentFailedToLoadAlert() {
        HapticsManager.shared.vibrate(for: .error)

        let alert: UIAlertController = {
            let alert = UIAlertController(title: "Unable to open",
                                          message: "We are unable to open article",
                                          preferredStyle: .alert)
            alert.addAction(.init(title: "Dismiss",
                                  style: .cancel,
                                  handler: nil))

            return alert
        }()

        present(alert, animated: true)
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: Header

    func tableView(_ tableView: UITableView, viewForHeaderInSection _: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: NewsHeaderView.identifier) as? NewsHeaderView else {
            return nil
        }
        header.configure(with: .init(title: type.title, shouldShowAddButton: false))

        return header
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        NewsHeaderView.preferredHeight
    }

    // MARK: Cell

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: NewsStoryTableViewCell.identifier, for: indexPath) as? NewsStoryTableViewCell else {
            fatalError()
        }
        cell.configure(with: .init(model: stories[indexPath.row]))
        cell.accessibilityIdentifier = "news_controller.table_cell"

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        NewsStoryTableViewCell.preferredHeight
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        stories.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let story = stories[indexPath.row]

        HapticsManager.shared.vibrateForSelection()

        guard let url = URL(string: story.url) else {
            presentFailedToLoadAlert()
            return
        }

        open(url: url)
    }
}

#if canImport(SwiftUI) && DEBUG
    import SwiftUI

    @available(iOS 14.0, *)
    struct NewsViewControllerPreview: PreviewProvider {
        static var previews: some View {
            UIViewControllerPreview {
                UINavigationController(rootViewController: NewsViewController(type: .topStories))
            }
            .previewLayout(.sizeThatFits)
            .environment(\.colorScheme, .light)
            .ignoresSafeArea(.all)
            .previewDeviceWithName(.iPhone12Pro)
        }
    }
#endif
