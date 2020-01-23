//
//  SettingsViewController.swift
//  oMoneyTest
//
//  Created by Radu Ursache on 22/01/2020.
//  Copyright © 2020 Radu Ursache. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {

	@IBOutlet weak var refreshSegControl: UISegmentedControl!
	@IBOutlet weak var setCurrencyButton: UIButton!
	
	private var currencyDataSource = [String]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.loadSavedData()
	}
	
	override func setupUI() {
		super.setupUI()
		
		self.updateButtonText()
		self.setCurrencyButton.layer.cornerRadius = 12
		self.setCurrencyButton.layer.borderColor = UIColor.label.cgColor
		self.setCurrencyButton.layer.borderWidth = 1
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(self.closeVC))
	}
	
	@IBAction func refreshSegControlAction(_ sender: UISegmentedControl) {
		guard let segmentTitle = sender.titleForSegment(at: sender.selectedSegmentIndex), let doubleSegmentTitle = Double(segmentTitle) else {
			return
		}
		
		DataManager.sharedInstance.saveRefreshInterval(interval: doubleSegmentTitle)
	}
	
	@IBAction func setCurrencyButtonAction(_ sender: Any) {
		var rowIndex = 0
		self.currencyDataSource = DataManager.sharedInstance.getAvailableCurrencies()
		let currentCurrency = DataManager.sharedInstance.getDefaultCurrency()
		if self.currencyDataSource.contains(currentCurrency) {
			rowIndex = self.currencyDataSource.firstIndex(of: currentCurrency)!
		}
		
		let alert = UIAlertController(title: "Set default currency", message: nil, preferredStyle: .actionSheet)
		alert.addPickerView(values: [self.currencyDataSource], initialSelection: (column: 0, row: rowIndex)) { vc, picker, index, values in
			DataManager.sharedInstance.saveDefaultCurrency(currency: self.currencyDataSource[index.row])
			
			DispatchQueue.main.async {
				self.updateButtonText()
			}
		}
		alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
	
	func loadSavedData() {
		// seg controller (try matching saved value to a segment and select it)
		for index in 0...self.refreshSegControl.numberOfSegments-1 {
			if self.refreshSegControl.titleForSegment(at: index) == String(format: "%.0f", DataManager.sharedInstance.getRefreshInterval()) {
				self.refreshSegControl.selectedSegmentIndex = index
				break
			}
		}
	}
	
	private func updateButtonText() {
		self.setCurrencyButton.setTitle("Change default currency (\(DataManager.sharedInstance.getDefaultCurrency()))", for: .normal)
	}
	
	@objc func closeVC() {
		self.dismiss(animated: true, completion: nil)
	}
}
