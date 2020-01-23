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
	
	var viewModel: HistoryViewModel?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
	}
	
	override func setupBindings() {
		super.setupBindings()
		
		self.viewModel = HistoryViewModel(parent: self, chartView: self.chartView, bottomLabel: self.bottomLabel, segControl: self.segmentControl)
		self.viewModel?.getHistoryData()
	}

	override func setupUI() {
		super.setupUI()
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshData))
	}
	
	@objc func refreshData() {
		self.viewModel?.getHistoryData()
	}
}

