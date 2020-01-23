//
//  HistoryViewController.swift
//  oMoneyTest
//
//  Created by Radu Ursache on 22/01/2020.
//  Copyright © 2020 Radu Ursache. All rights reserved.
//

import UIKit
import Charts

class HistoryViewController: BaseViewController {

	@IBOutlet weak var segmentControl: UISegmentedControl!
	@IBOutlet weak var chartView: LineChartView!
	@IBOutlet weak var bottomLabel: UILabel!
	
	var historyViewModel: HistoryViewModel?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
	}
	
	override func setupBindings() {
		super.setupBindings()
		
		self.historyViewModel = HistoryViewModel(parent: self, chartView: self.chartView, bottomLabel: self.bottomLabel, segControl: self.segmentControl)
		self.historyViewModel?.getHistoryData()
	}

	override func setupUI() {
		super.setupUI()
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshData))
	}
	
	@objc func refreshData() {
		self.historyViewModel?.getHistoryData()
	}
	
	// catch darkmode change to reload chart appearance
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

		// traitCollectionDidChange gets fired multiple times, only catch the valid ones
        guard UIApplication.shared.applicationState == .inactive else {
            return
        }

		self.historyViewModel?.loadChartView(animate: false)
    }
}

