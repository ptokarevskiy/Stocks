import UIKit

// MARK: - SearchResultsViewControllerDelegate

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidSelect(searchResult: SearchResult)
}

// MARK: - SearchResultsViewController

class SearchResultsViewController: UIViewController {
    weak var delegate: SearchResultsViewControllerDelegate?

    private var results: [SearchResult] = []

    private let tableView: UITableView = {
        let table = UITableView()

        table.register(SearchResultTableViewCell.self,
                       forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        table.isHidden = true

        return table
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setUpTableView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.frame = view.bounds
    }

    // MARK: - Private

    private func setUpTableView() {
        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - Public

    public func update(withResults results: [SearchResult]) {
        self.results = results

        tableView.isHidden = results.isEmpty
        tableView.reloadData()
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath)
        let model = results[indexPath.row]

        cell.textLabel?.text = model.displaySymbol
        cell.detailTextLabel?.text = model.description
        cell.accessibilityIdentifier = "search_results.company_cell"

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchResult = results[indexPath.row]

        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.searchResultsViewControllerDidSelect(searchResult: searchResult)
    }
}

#if canImport(SwiftUI) && DEBUG
    import SwiftUI

    @available(iOS 14.0, *)
    struct SearchResultsViewControllerPreview: PreviewProvider {
        static var previews: some View {
            UIViewControllerPreview {
                UINavigationController(rootViewController: SearchResultsViewController())
            }.previewLayout(.sizeThatFits)
                .environment(\.colorScheme, .light)
                .ignoresSafeArea(.all)
        }
    }
#endif
