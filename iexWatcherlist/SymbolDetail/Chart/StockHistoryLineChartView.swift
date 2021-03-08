//
//  StockHistoryLineChartView.swift
//  iexWatcherlist
//
//  Created by Xiang Liu on 3/5/21.
//

import Foundation
import UIKit
import Charts

class StockHistoryLineChartView: UIView {
    
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .clear
        chartView.delegate = self
        chartView.chartDescription?.enabled = false
        
        chartView.dragEnabled = false
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false
        
        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.setLabelCount(6, force: false)
        leftAxis.labelTextColor = .white
        leftAxis.axisLineColor = .white
        leftAxis.labelFont = .boldSystemFont(ofSize: 12)
        leftAxis.drawGridLinesEnabled = false
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        chartView.xAxis.labelTextColor = .white
        chartView.xAxis.axisLineColor = .white
        chartView.xAxis.setLabelCount(6, force: true)
        chartView.xAxis.drawGridLinesEnabled = false
        
        chartView.rightAxis.enabled = false
        
        chartView.legend.form = .circle
        chartView.legend.textColor = .white
        
        chartView.xAxis.valueFormatter = XAxisValueFormatter()
        
        return chartView
    }()
    
    init() {
        super.init(frame: .zero)
        addSubview(lineChartView)
        lineChartView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setupData(prices: [HistoricalPrice]) {
        let color: UIColor = (prices.first?.chartData.y ?? 0) >= (prices.last?.chartData.y ?? 0) ? .systemRed : .systemGreen
        let entries = prices.map { $0.chartData }
        let set = LineChartDataSet(entries: entries, label: "midium price")
        set.drawCircleHoleEnabled = false
        set.drawCirclesEnabled = true
        set.circleColors = [.lightGray]
        set.valueColors = [UIColor.white]
        set.circleRadius = 3
        set.mode = .cubicBezier
        set.lineWidth = 2
        set.setColor(color, alpha: 0.7)
        if let gradient = self.setGradientBackground(topColor: color) {
            set.fill = Fill(radialGradient: gradient)
        } else {
            set.fill = Fill(color: color)
        }
        set.fillAlpha = 0.7
        set.drawFilledEnabled = true
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.highlightColor = .white
        let data = LineChartData(dataSet: set)
        data.setDrawValues(false)
        lineChartView.data = data
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init?(coder:) has not been implemented")
    }
    
    private func setGradientBackground(topColor: UIColor) -> CGGradient? {
        let colours = [topColor.cgColor, UIColor.black.cgColor] as CFArray
        return  CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colours, locations: [0.0, 1.0])
    }
}

// MARK: - ChartViewDelegate
extension StockHistoryLineChartView: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        var set = LineChartDataSet()
        set = (chartView.data?.dataSets[0] as? LineChartDataSet)!

        set.drawValuesEnabled = true
        chartView.setNeedsDisplay()
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        var set = LineChartDataSet()
        set = (chartView.data?.dataSets[0] as? LineChartDataSet)!

        set.drawValuesEnabled = false
        chartView.setNeedsDisplay()
    }
}

class XAxisValueFormatter: NSObject, IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "M-d"
        let date = Date(timeIntervalSince1970: value)
        let time = dateFormatterPrint.string(from: date)
        return time
    }
}
