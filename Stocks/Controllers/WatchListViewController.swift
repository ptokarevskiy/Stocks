import FloatingPanel
import os.log
import UIKit

// MARK: - WatchListViewController

class WatchListViewController: UIViewController {
    static var maxChangeWidth: CGFloat = 0

    private let tableView: UITableView = .init()

    private var searchTimer: Timer?
    private var floatingPanel: FloatingPanelController?
    private var watchlistMap: [String: [CandleStick]] = [:]
    private var viewModels: [WatchListTableViewCell.ViewModel] = []
    private var observer: NSObjectProtocol?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        setUpSearchController()
        setUpTableView()
        fetchWatchlistData()
        setUpFloatingPanel()
        setUpTitleView()
        setUpObserver()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.frame = view.bounds
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        navigationItem.hidesSearchBarWhenScrolling = true
    }

    // MARK: - Private

    private func setUpSearchController() {
        let resultsViewController = SearchResultsViewController()
        let searchViewController = UISearchController(searchResultsController: resultsViewController)

        resultsViewController.delegate = self
        searchViewController.searchResultsUpdater = self
        navigationItem.searchController = searchViewController
        navigationItem.searchController?.searchBar.searchTextField.accessibilityIdentifier = "watchlist.search_field"
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func setUpTableView() {
        tableView.register(WatchListTableViewCell.self,
                           forCellReuseIdentifier: WatchListTableViewCell.identifier)
        tableView.accessibilityIdentifier = "watchlist.table_view"
        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setUpTitleView() {
        guard let navigationBar = navigationController?.navigationBar else {
            return
        }

        let titleView: UIView = .init(frame: .init(x: 0,
                                                   y: 0,
                                                   width: view.width,
                                                   height: navigationBar.height))
        let label: UILabel = {
            let label = UILabel(frame: .init(x: 10,
                                             y: 0,
                                             width: titleView.width - 20,
                                             height: titleView.height))
            label.text = "Stocks"
            label.font = .systemFont(ofSize: 38, weight: .bold)

            return label
        }()

        titleView.addSubview(label)
        navigationItem.titleView = titleView
    }

    private func setUpFloatingPanel() {
        let contentViewController = NewsViewController(type: .topStories)
        let panelController = FloatingPanelController(delegate: self)

        panelController.surfaceView.backgroundColor = .secondarySystemBackground
        panelController.set(contentViewController: contentViewController)
        panelController.addPanel(toParent: self)
        panelController.track(scrollView: contentViewController.tableView)
    }

    private func fetchWatchlistData() {
        let symbols = PersistenceManager.shared.watchlist

        createPlaceholderViewModels()

        let group = DispatchGroup()

        for symbol in symbols where watchlistMap[symbol] == nil {
            group.enter()

            APIManager.shared.marketData(for: symbol) { [weak self] result in
                defer {
                    group.leave()
                }

                switch result {
                case let .success(data):
                    let candleSticks = data.candleSticks
                    self?.watchlistMap[symbol] = candleSticks

                case let .failure(error):
                    os_log(.debug,
                           "Failed to fetch market data for %{public}@ with error: <%{public}@>",
                           symbol,
                           error.localizedDescription)
                }
            }
        }

        group.notify(queue: .main) { [weak self] in
            self?.createViewModels()
            self?.tableView.reloadData()
        }
    }

    private func createPlaceholderViewModels() {
        let symbols = PersistenceManager.shared.watchlist

        symbols.forEach { item in
            viewModels.append(.init(symbol: item,
                                    companyName: UserDefaults.standard.string(forKey: item) ?? "",
                                    price: "Loading...",
                                    changeColor: .systemGreen,
                                    changePercentage: "",
                                    chartViewModel: .init(data: [],
                                                          showLegend: false,
                                                          showAxis: false,
                                                          fillColor: .clear)))
        }

        tableView.reloadData()
    }

    private func createViewModels() {
        var viewModels = [WatchListTableViewCell.ViewModel]()
        for (symbol, candleSticks) in watchlistMap {
            let changePercentage = candleSticks.getPercentage()

            viewModels.append(.init(symbol: symbol,
                                    companyName: UserDefaults.standard.string(forKey: symbol) ?? "Company",
                                    price: getLatestClosingPrice(for: candleSticks),
                                    changeColor: changePercentage < 0 ? .systemRed : .systemGreen,
                                    changePercentage: .percentage(from: changePercentage),
                                    chartViewModel: .init(data: candleSticks.reversed().map(\.close),
                                                          showLegend: false,
                                                          showAxis: false,
                                                          fillColor: changePercentage < 0 ? .systemRed : .systemGreen)))
        }

        self.viewModels = viewModels.sorted(by: { $0.symbol < $1.symbol })
        tableView.reloadData()
    }

    private func getLatestClosingPrice(for data: [CandleStick]) -> String {
        guard let closingPrice = data.first?.close else {
            return ""
        }

        return .formatted(number: closingPrice)
    }

    private func setUpObserver() {
        observer = NotificationCenter.default.addObserver(forName: .didAddToWatchlist,
                                                          object: nil,
                                                          queue: .main,
                                                          using: { [weak self] _ in
                                                              self?.viewModels.removeAll()
                                                              self?.fetchWatchlistData()
                                                          })
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
            APIManager.shared.search(query: query) { result in
                switch result {
                case let .success(response):
                    DispatchQueue.main.async {
                        resultsViewController.update(withResults: response.result)
                    }

                case let .failure(error):
                    DispatchQueue.main.async {
                        resultsViewController.update(withResults: [])
                    }

                    os_log(.debug,
                           "Failed to fetch search results for query <%{public}@> with error: <%{public}@>",
                           query,
                           error.localizedDescription)
                }
            }
        })
    }
}

// MARK: SearchResultsViewControllerDelegate

extension WatchListViewController: SearchResultsViewControllerDelegate {
    func searchResultsViewControllerDidSelect(searchResult: SearchResult) {
        let stockDetailsViewController = StockDetailsViewController(symbol: searchResult.displaySymbol,
                                                                    companyName: searchResult.description)
        let navigationViewController = UINavigationController(rootViewController: stockDetailsViewController)

        HapticsManager.shared.vibrateForSelection()

        navigationItem.searchController?.searchBar.resignFirstResponder()
        stockDetailsViewController.title = searchResult.description
        present(navigationViewController, animated: true)
    }
}

// MARK: FloatingPanelControllerDelegate

extension WatchListViewController: FloatingPanelControllerDelegate {
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        UIView.animate(withDuration: 1) { [weak self] in
            self?.navigationItem.titleView?.isHidden = fpc.state == .full
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension WatchListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WatchListTableViewCell.identifier,
                                                       for: indexPath) as? WatchListTableViewCell else {
            fatalError()
        }

        cell.configure(with: viewModels[indexPath.row])
        cell.delegate = self
        cell.accessibilityIdentifier = "watchlist.company_cell"

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        WatchListTableViewCell.preferredHeight
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModels.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = viewModels[indexPath.row]
        let viewController = StockDetailsViewController(symbol: viewModel.symbol,
                                                        companyName: viewModel.companyName,
                                                        candleStickData: watchlistMap[viewModel.symbol] ?? [])
        let navigationController = UINavigationController(rootViewController: viewController)

        HapticsManager.shared.vibrateForSelection()

        tableView.deselectRow(at: indexPath, animated: true)
        present(navigationController, animated: true)
    }

    func tableView(_: UITableView, canEditRowAt _: IndexPath) -> Bool {
        true
    }

    func tableView(_: UITableView, editingStyleForRowAt _: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()

            // Update persistence
            PersistenceManager.shared.removeFromWatchlist(symbol: viewModels[indexPath.row].symbol)

            // Update model
            viewModels.remove(at: indexPath.row)

            // Delete row
            tableView.deleteRows(at: [indexPath], with: .automatic)

            tableView.endUpdates()
        }
    }
}

// MARK: WatchListTableViewCellDelegate

extension WatchListViewController: WatchListTableViewCellDelegate {
    func didUpdateMaxWidth() {
        tableView.reloadData()
    }
}

#if canImport(SwiftUI) && DEBUG
    import SwiftUI

    @available(iOS 14.0, *)
    struct WatchListViewControllerPreview: PreviewProvider {
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
