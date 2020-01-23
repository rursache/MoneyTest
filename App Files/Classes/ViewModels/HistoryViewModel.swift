//
//  HistoryViewModel.swift
//  oMoneyTest
//
//  Created by Radu Ursache on 23/01/2020.
//  Copyright © 2020 Radu Ursache. All rights reserved.
//

import Foundation
import UIKit
import Charts
import PKHUD

class HistoryViewModel: NSObject, ChartViewDelegate {
	
	var parent: HistoryViewController?
	var segmentControl: UISegmentedControl?
	var chartView: LineChartView?
	var bottomLabel: UILabel?
	
	private var responseDataSource = [String: [String: Double]]()
	private var cleanDataSource = [[String: Double]]()
	
	private var baseCurrency = String()
	
	init(parent: HistoryViewController, chartView: LineChartView, bottomLabel: UILabel, segControl: UISegmentedControl) {
		super.init()
		
		self.parent = parent
		self.chartView = chartView
		self.bottomLabel = bottomLabel
		self.segmentControl = segControl

		self.updateBaseCurrency()
		self.setupChartView()
		self.setupDelegates()
	}
	
	private func setupDelegates() {
		self.chartView?.delegate = self
		
		self.segmentControl?.addTarget(self, action: #selector(self.segControlAction), for: .valueChanged)
	}
	
	@objc private func segControlAction() {
		self.updateBaseCurrency()
		self.loadChartView()
	}
	
	func getHistoryData(days: TimeInterval = 10) {
		// api will sometimes return less values than requested. maybe keep incrementing requested days until we get 10?
		APIClient.sharedInstance.getHistory(base: self.baseCurrency, startDate: Date().addingTimeInterval(-days*24*60*60), endDate: Date()) { (historyRatesModel, error) in
			if error != nil {
				self.showError(error: error!.localizedDescription)
				return
			}
			
			if let history = historyRatesModel?.rates {
				self.responseDataSource = history
				self.loadChartView(animate: true)
			} else {
				self.showError(error: "Invalid API Response")
			}
		}
	}
	
	private func setupChartView() {
		self.chartView?.setViewPortOffsets(left: 20, top: 25, right: 20, bottom: 10)
		self.chartView?.backgroundColor = .systemBackground
        
        self.chartView?.dragEnabled = false
        self.chartView?.setScaleEnabled(false)
        
        self.chartView?.xAxis.enabled = true
		chartView?.xAxis.drawAxisLineEnabled = false
		chartView?.xAxis.labelFont = .systemFont(ofSize: 8)
		chartView?.xAxis.labelTextColor = .label
		chartView?.xAxis.axisLineColor = .white
		chartView?.xAxis.valueFormatter = DateValueFormatter()
        
		self.chartView?.leftAxis.enabled = false
        self.chartView?.rightAxis.enabled = false
        self.chartView?.legend.enabled = false
	}
	
	func loadChartView(animate: Bool = false) {
		// let's keep DATE: VALUE only, currency is set already
		self.cleanDataSource = [[String: Double]]()
		for key in self.responseDataSource.keys {
			if let valueForBaseCurrency = self.responseDataSource[key]?[self.baseCurrency] {
				self.cleanDataSource.append([key: valueForBaseCurrency])
			}
		}
		
		// sort by date
		self.cleanDataSource = self.cleanDataSource.sorted { $0.keys.first! < $1.keys.first! }
		
		// create chart items
		var chartDataSource = [ChartDataEntry]()
		for item in self.cleanDataSource {
			guard let dateString = item.keys.first,
					let date = Constants.Helpers.backendDateFormatter.date(from: dateString),
						let itemValue = item[dateString] else {
				break
			}
			chartDataSource.append(ChartDataEntry(x: date.timeIntervalSince1970, y: itemValue))
		}
		
		let dataSet = LineChartDataSet(entries: chartDataSource, label: self.baseCurrency)
		dataSet.mode = .cubicBezier
        dataSet.drawCirclesEnabled = true
        dataSet.lineWidth = 0
        dataSet.setCircleColor(.label)
		dataSet.fillAlpha = 1
		dataSet.fill = Fill(linearGradient: CGGradient(colorsSpace: nil, colors: [Constants.Config.appColor.cgColor, UIColor.systemBackground.cgColor] as CFArray, locations: nil)!, angle: 270)
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
		dataSet.drawFilledEnabled = true
		dataSet.cubicIntensity = 0.05
		dataSet.valueFormatter = CurrencyValueFormatter()
		dataSet.valueColors = [.label]
        
        let data = LineChartData(dataSet: dataSet)
		data.setValueFont(.preferredFont(forTextStyle: .caption2))
        data.setDrawValues(true)
        
		self.chartView?.data = data
		self.chartView?.animate(xAxisDuration: animate ? 1.5 : 0)
		
		self.bottomLabel?.text = "Showing the development of \(self.baseCurrency) against EUR in the last \(String(format: "%d", self.cleanDataSource.count)) days"
	}
	
	private func showError(error: String) {
		print(error)
		HUD.flash(.labeledError(title: nil, subtitle: error), onView: nil, delay: Constants.Config.hudDurationOnScreen, completion: nil)
	}
	
	private func updateBaseCurrency() {
		if let selectedIndex = self.segmentControl?.selectedSegmentIndex, let baseCurrency = self.segmentControl?.titleForSegment(at: selectedIndex) {
			self.baseCurrency = baseCurrency
		}
	}
}

fileprivate class DateValueFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
		self.dateFormatter.dateFormat = "dd/MM"
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value)) + "\n" // walkaround for overlapping labels. there must be a better way
    }
}

fileprivate class CurrencyValueFormatter: NSObject, IValueFormatter {
	func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
		return String(format: "%.3f", value)
	}
}
