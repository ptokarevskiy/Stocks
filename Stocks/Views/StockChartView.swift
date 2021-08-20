import Charts
import UIKit

class StockChartView: UIView {
    struct ViewModel {
        let data: [Double]
        let showLegend: Bool
        let showAxis: Bool
    }

    private let chartView: LineChartView = {
        let chartView = LineChartView()
        chartView.pinchZoomEnabled = false
        chartView.setScaleEnabled(true)
        chartView.xAxis.enabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        chartView.legend.enabled = false

        return chartView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        chartView.frame = bounds
        addSubview(chartView)
    }

    func reset() {
        chartView.data = nil
    }

    func configure(with viewModel: ViewModel) {
        var entries = [ChartDataEntry]()

        for (index, value) in viewModel.data.enumerated() {
            entries.append(.init(x: Double(index),
                                 y: value))
        }

        let dataSet = LineChartDataSet(entries: entries, label: "Legend")
        let data = LineChartData(dataSet: dataSet)

        dataSet.fillColor = .systemBlue
        dataSet.drawFilledEnabled = true
        dataSet.drawIconsEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.drawCirclesEnabled = false
        chartView.data = data
    }
}
