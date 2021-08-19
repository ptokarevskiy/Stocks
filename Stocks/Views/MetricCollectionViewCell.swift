import UIKit

class MetricCollectionViewCell: UICollectionViewCell {
    static let identifier = "MetricCollectionViewCell"

    private let nameLabel: UILabel = {
        let label = UILabel()

        return label
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel

        return label
    }()

    struct ViewModel {
        let name: String
        let value: String
    }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.clipsToBounds = true
        addSubviews(nameLabel, valueLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        valueLabel.sizeToFit()
        nameLabel.sizeToFit()
        nameLabel.frame = .init(x: 3, y: 0, width: nameLabel.width, height: contentView.height)
        valueLabel.frame = .init(x: nameLabel.right + 3, y: 0, width: valueLabel.width, height: contentView.height)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        nameLabel.text = nil
        valueLabel.text = nil
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    func configure(with viewModel: ViewModel) {
        nameLabel.text = viewModel.name + ":"
        valueLabel.text = viewModel.value
    }
}
