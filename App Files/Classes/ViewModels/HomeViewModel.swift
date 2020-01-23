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
	private var valueTextField: UITextField?
	private var baseCurrencyButton: UIButton?
	private var dataSource = [String: Double]()
	private var arrayDataSource = [String]()
	private let refreshControl = UIRefreshControl()
	
	init(parent: HomeViewController, tableView: UITableView, lastUpdatedLabel: UILabel, valueTextField: UITextField, baseCurrencyButton: UIButton) {
		super.init()
		
		self.parent = parent
		self.tableView = tableView
		self.lastUpdatedLabel = lastUpdatedLabel
		self.valueTextField = valueTextField
		self.baseCurrencyButton = baseCurrencyButton
		self.setupBindings()
		self.setupUI()
	}
	
	private func setupBindings() {
		self.tableView?.delegate = self
		self.tableView?.dataSource = self
		
		self.baseCurrencyButton?.addTarget(self, action: #selector(self.baseCurrencyButtonAction), for: UIControl.Event.touchUpInside)
		self.valueTextField?.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
		self.refreshControl.addTarget(self, action: #selector(self.getCurrencyData), for: .valueChanged)
	}
	
	private func setupUI() {
		self.refreshControl.tintColor = Constants.Config.appColor
		
		self.tableView?.refreshControl = self.refreshControl
		self.tableView?.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1)) // remove bottom separator
	}
	
	@objc func getCurrencyData() {
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
				
				self.refreshControl.endRefreshing()
				self.tableView?.reloadData()
				
				self.lastUpdatedLabel?.text = "Updated at: " + Constants.Helpers.timestampDateFormatter.string(from: Date())
				self.baseCurrencyButton?.setTitle(baseCurrency, for: .normal)
				self.baseCurrencyButton?.setImage(UIImage(named: baseCurrency.lowercased()), for: .normal)
			} else {
				self.showError(error: "Invalid API Response")
			}
		}
	}
	
	private func showError(error: String) {
		print(error)
		HUD.flash(.labeledError(title: nil, subtitle: error), onView: nil, delay: Constants.Config.hudDurationOnScreen, completion: nil)
		self.parent?.stopTimer()
	}
	
	@objc func textFieldDidChange(_ textField: UITextField) {
		self.tableView?.reloadData()
	}
	
	@objc func baseCurrencyButtonAction() {
		// weird contraint issues here, ios sdk bug since ios 12.2, walkaround available: https://stackoverflow.com/a/58666480/1880111
		let actionSheet = UIAlertController(title: " ", message: "Select base currency", preferredStyle: .actionSheet)
		for currency in DataManager.sharedInstance.getAvailableCurrencies() {
			let actionImage = UIImage(named: currency.lowercased())!.withRenderingMode(.alwaysOriginal)
			let actionItem = UIAlertAction(title: currency, style: .default, handler: { [weak self] _ in
				DataManager.sharedInstance.saveDefaultCurrency(currency: currency)
				self?.getCurrencyData()
			})
			actionItem.setValue(actionImage, forKey: "image")
			actionSheet.addAction(actionItem)
		}
		actionSheet.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
		self.parent?.present(actionSheet, animated: true, completion: nil)
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
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		let currencyCode = self.arrayDataSource[indexPath.row]
		DataManager.sharedInstance.saveDefaultCurrency(currency: currencyCode)
		self.getCurrencyData()
	}
}
