import UIKit

// MARK: - NewsViewController

class NewsViewController: UIViewController {
    let tableView: UITableView = {
        let table = UITableView()

        table.register(NewsHeaderView.self,
                       forHeaderFooterViewReuseIdentifier: NewsHeaderView.identifier)
        table.register(NewsStoryTableViewCell.self,
                       forCellReuseIdentifier: NewsStoryTableViewCell.identifier)
        table.backgroundColor = .clear

        return table
    }()

    private let type: NewsViewControllerType
    private var stories: [NewsStory] = [.init(category: "tech",
                                              datetime: 123,
                                              headline: "headline",
                                              id: 1, image: "",
                                              related: "relateed",
                                              source: "Panorama",
                                              summary: "", url: "")]

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

    init(type: NewsViewControllerType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
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
        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self
    }

    private func fetchNews() {}

    private func open(url: URL) {}
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: Header

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: NewsHeaderView.identifier) as? NewsHeaderView else {
            return nil
        }
        header.configure(with: .init(title: type.title, shouldShowAddButton: false))

        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        NewsHeaderView.preferredHeight
    }

    // MARK: Cell

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: NewsStoryTableViewCell.identifier, for: indexPath) as? NewsStoryTableViewCell else {
            fatalError()
        }
        cell.configure(with: .init(model: stories[indexPath.row]))

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        NewsStoryTableViewCell.preferredHeight
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stories.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

#if canImport(SwiftUI) && DEBUG
    import SwiftUI

    @available(iOS 14.0, *)
    struct NewsViewController_Preview: PreviewProvider {
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
