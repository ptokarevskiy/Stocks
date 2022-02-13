import UIKit

// MARK: - StockDetailHeaderView

class StockDetailHeaderView: UIView {
    private var metricsViewModels: [MetricCollectionViewCell.ViewModel] = []
    private let chartView = StockChartView()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.register(MetricCollectionViewCell.self,
                                forCellWithReuseIdentifier: MetricCollectionViewCell.identifier)

        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        clipsToBounds = true
        addSubviews(chartView, collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        chartView.frame = .init(x: 0, y: 0, width: width, height: height - 100)
        collectionView.frame = .init(x: 0, y: height - 100, width: width, height: 100)
    }

    public func configure(chartViewModel: StockChartView.ViewModel,
                          metricsViewModels: [MetricCollectionViewCell.ViewModel]) {
        chartView.configure(with: chartViewModel)

        self.metricsViewModels = metricsViewModels
        collectionView.reloadData()
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension StockDetailHeaderView: UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout {
    func numberOfSections(in _: UICollectionView) -> Int {
        1
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        metricsViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
        let viewModel = metricsViewModels[indexPath.row]

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MetricCollectionViewCell.identifier,
                                                            for: indexPath) as? MetricCollectionViewCell else {
            fatalError()
        }

        cell.configure(with: viewModel)

        return cell
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        CGSize(width: width / 2, height: 100 / 3)
    }
}
