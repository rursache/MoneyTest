//
//  HomeViewModel.swift
//  oMoneyTest
//
//  Created by Radu Ursache on 22/01/2020.
//  Copyright © 2020 Radu Ursache. All rights reserved.
//

import Foundation
import UIKit
import PKHUD

class HomeViewModel: NSObject {
	
	private var parent: HomeViewController?
	private var tableView: UITableView?
	private var lastUpdatedLabel: UILabel?
	private var baseCurrencyLabel: UILabel?
	private var valueTextField: UITextField?
	
	private var dataSource = [String: Double]()
	private var arrayDataSource = [String]()
	
	init(parent: HomeViewController, tableView: UITableView, lastUpdatedLabel: UILabel, valueTextField: UITextField, baseCurrencyLabel: UILabel) {
		super.init()
		
		self.parent = parent
		self.tableView = tableView
		self.lastUpdatedLabel = lastUpdatedLabel
		self.valueTextField = valueTextField
		self.baseCurrencyLabel = baseCurrencyLabel
		
		self.setupDelegates()
		self.setupUI()
	}
	
	private func setupDelegates() {
		self.tableView?.delegate = self
		self.tableView?.dataSource = self
		
		self.valueTextField?.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
	}
	
	private func setupUI() {
		self.tableView?.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1)) // remove bottom separator
	}
	
	func getCurrencyData() {
		let baseCurrency = DataManager.sharedInstance.getDefaultCurrency()
		APIClient.sharedInstance.getRates(base: baseCurrency) { (latestRatesModel, error) in
			if error != nil {
				self.showError(error: error!.localizedDescription)
				return
			}
			
			if let rates = latestRatesModel?.rates {
				self.dataSource = rates
				self.arrayDataSource = rates.keys.sorted { $0.lowercased() < $1.lowercased() }
				
				DataManager.sharedInstance.setAvailableCurrencies(currencies: self.arrayDataSource)
				
				self.tableView?.reloadData()
				
				self.lastUpdatedLabel?.text = "Updated at: " + Constants.Helpers.timestampDateFormatter.string(from: Date())
				self.baseCurrencyLabel?.text = "Base currency: " + baseCurrency
			} else {
				self.showError(error: "Invalid API Response")
			}
		}
	}
	
	private func showError(error: String) {
		print(error)
		HUD.show(.labeledError(title: nil, subtitle: error))
	}
	
	@objc func textFieldDidChange(_ textField: UITextField) {
		self.tableView?.reloadData()
	}
}

extension HomeViewModel: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.arrayDataSource.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: HomeCell.getIdentifier(), for: indexPath) as! HomeCell
		
		let currentItemKey = self.arrayDataSource[indexPath.row]
		let currentItemValue = self.dataSource[currentItemKey]
		
		var multiplyer: Double = 1.0
		if let currencyMultiplyer = Double((self.valueTextField?.text)!), currencyMultiplyer >= 1.0 {
			multiplyer = currencyMultiplyer
		}
		
		cell.loadData(currencyName: currentItemKey, currencyValue: currentItemValue! * multiplyer)
		
		return cell
	}
}
