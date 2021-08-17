import SafariServices
import UIKit

// MARK: - StockDetailsViewController

class StockDetailsViewController: UIViewController {
    // MARK: - Properties

    private let symbol: String
    private let companyName: String
    private var candleStickData: [CandleStick]
    private var stories: [NewsStory] = []

    private let tableView: UITableView = {
        let table = UITableView()

        table.register(NewsHeaderView.self,
                       forHeaderFooterViewReuseIdentifier: NewsHeaderView.identifier)
        table.register(NewsStoryTableViewCell.self,
                       forCellReuseIdentifier: NewsStoryTableViewCell.identifier)

        return table
    }()

    // MARK: - Init

    init(symbol: String, companyName: String, candleStickData: [CandleStick] = []) {
        self.symbol = symbol
        self.companyName = companyName
        self.candleStickData = candleStickData
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = companyName

        setUpCloseButton()
        setUpTable()
        fetchFinancialData()
        fetchNews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.frame = view.bounds
    }

    private func setUpCloseButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                            target: self,
                                                            action: #selector(didTapClose))
    }

    @objc
    private func didTapClose() {
        dismiss(animated: true)
    }

    private func setUpTable() {
        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView(frame: .init(x: 0,
                                                        y: 0,
                                                        width: view.width,
                                                        height: (view.width * 0.7) + 100))
    }

    private func fetchFinancialData() {
        renderChart()
    }

    private func renderChart() {}

    private func fetchNews() {
        APICaller.shared.news(for: .company(symbol: symbol)) { [weak self] result in
            switch result {
            case let .success(stories):
                DispatchQueue.main.async {
                    self?.stories = stories
                    self?.tableView.reloadData()
                }

            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension StockDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: Header

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: NewsHeaderView.identifier) as? NewsHeaderView else {
            return nil
        }
        header.delegate = self
        header.configure(with:
            .init(title: symbol.uppercased(),
                  shouldShowAddButton: !PersistenceManager.shared.watchListContains(symbol: symbol)))

        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        NewsHeaderView.preferredHeight
    }

    // MARK: Cells

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsStoryTableViewCell.identifier,
                                                       for: indexPath) as? NewsStoryTableViewCell else {
            fatalError()
        }
        cell.configure(with: .init(model: stories[indexPath.row]))

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        NewsStoryTableViewCell.preferredHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: stories[indexPath.row].url) else { return }
        let webView = SFSafariViewController(url: url)

        tableView.deselectRow(at: indexPath, animated: true)
        present(webView, animated: true)
    }
}

// MARK: NewsHeaderViewDelegate

extension StockDetailsViewController: NewsHeaderViewDelegate {
    func newsHeaderViewDidAddButton(_ headerView: NewsHeaderView) {
        headerView.button.isHidden = true
        PersistenceManager.shared.addToWatchList(symbol: symbol, companyName: companyName)

        let alert: UIAlertController = {
            let alert = UIAlertController(title: "Added to Watchlist",
                                          message: "\(companyName) added to your watchlist",
                                          preferredStyle: .alert)
            alert.addAction(.init(title: "Dismiss", style: .cancel, handler: nil))

            return alert
        }()

        present(alert, animated: true)
    }
}

#if canImport(SwiftUI) && DEBUG
    import SwiftUI

    @available(iOS 14.0, *)
    struct StockDetailsViewController_Preview: PreviewProvider {
        static var previews: some View {
            UIViewControllerPreview {
                UINavigationController(rootViewController: StockDetailsViewController(symbol: "SNAP", companyName: "Snapchat"))
            }
            .previewLayout(.sizeThatFits)
            .environment(\.colorScheme, .light)
            .ignoresSafeArea(.all)
            .previewDeviceWithName(.iPhone12Pro)
        }
    }
#endif
