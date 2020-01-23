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
	@IBOutlet weak var chartBottomConstraint: NSLayoutConstraint!
	
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
		
		self.bottomLabel.isHidden = true
		
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .done, target: self, action: #selector(self.showHistoryDescriptionAlert))
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshData))
	}
	
	@objc func refreshData() {
		self.historyViewModel?.getHistoryData()
	}
	
	@objc func showHistoryDescriptionAlert() {
		guard let historyDescString = self.historyViewModel?.historyDescriptionString else {
			return
		}
		
		let alert = UIAlertController(title: Constants.Config.appName, message: historyDescString, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		self.present(alert, animated: true, completion: nil)
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
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
		
        if UIDevice.current.orientation.isLandscape {
			self.chartBottomConstraint.constant = 10
        } else {
            self.chartBottomConstraint.constant = 250
        }
    }
}

