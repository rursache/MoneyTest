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
	@IBOutlet weak var currencyPicker: UIPickerView!
	
	private var currencyDataSource = [String]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.loadSavedData()
	}
	
	override func setupBindings() {
		super.setupBindings()
		
		self.currencyPicker.delegate = self
		self.currencyPicker.dataSource = self
	}
	
	@IBAction func refreshSegControlAction(_ sender: UISegmentedControl) {
		guard let segmentTitle = sender.titleForSegment(at: sender.selectedSegmentIndex), let doubleSegmentTitle = Double(segmentTitle) else {
			return
		}
		
		DataManager.sharedInstance.saveRefreshInterval(interval: doubleSegmentTitle)
	}
	
	func loadSavedData() {
		// picker
		if let availableCurrencies = DataManager.sharedInstance.getAvailableCurrencies() {
			self.currencyDataSource = availableCurrencies
			let currentCurrency = DataManager.sharedInstance.getDefaultCurrency()
			if self.currencyDataSource.contains(currentCurrency) {
				self.currencyPicker.selectRow(self.currencyDataSource.firstIndex(of: currentCurrency)!, inComponent: 0, animated: true)
			}
		}
		
		// seg controller (try matching saved value to a segment and select it)
		for index in 0...self.refreshSegControl.numberOfSegments-1 {
			if self.refreshSegControl.titleForSegment(at: index) == String(format: "%.0f", DataManager.sharedInstance.getRefreshInterval()) {
				self.refreshSegControl.selectedSegmentIndex = index
				break
			}
		}
	}
}

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return self.currencyDataSource.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return self.currencyDataSource[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		DataManager.sharedInstance.saveDefaultCurrency(currency: self.currencyDataSource[row])
	}
}
