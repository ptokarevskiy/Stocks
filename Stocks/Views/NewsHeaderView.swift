import UIKit

// MARK: - NewsHeaderViewDelegate

protocol NewsHeaderViewDelegate: AnyObject {
    func newsHeaderViewDidAddButton(_ headerView: NewsHeaderView)
}

// MARK: - NewsHeaderView

class NewsHeaderView: UITableViewHeaderFooterView {
    struct ViewModel {
        let title: String
        let shouldShowAddButton: Bool
    }

    static let identifier = "NewsHeaderView"
    static let preferredHeight: CGFloat = 70

    weak var delegate: NewsHeaderViewDelegate?

    private let label: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 32)
        label.accessibilityIdentifier = "news_header_view.company_symbol"

        return label
    }()

    let button: UIButton = {
        let button = UIButton()
        button.setTitle("+ Watchlist", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.accessibilityIdentifier = "news_header_view.add_to_watchlist_button"

        return button
    }()

    // MARK: - Init

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(label, button)

        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        label.frame = .init(x: 14, y: 0, width: contentView.width - 28, height: contentView.height)
        button.sizeToFit()
        button.frame = .init(x: contentView.width - button.width - 16,
                             y: (contentView.height - button.height) / 2,
                             width: button.width + 8,
                             height: button.height)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        label.text = nil
    }

    // MARK: - Private

    @objc
    private func didTapButton() {
        delegate?.newsHeaderViewDidAddButton(self)
    }

    // MARK: - Public

    public func configure(with viewModel: ViewModel) {
        label.text = viewModel.title
        button.isHidden = !viewModel.shouldShowAddButton
    }
}
