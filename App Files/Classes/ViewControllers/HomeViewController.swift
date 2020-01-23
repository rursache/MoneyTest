//
//  HomeViewController.swift
//  oMoneyTest
//
//  Created by Radu Ursache on 22/01/2020.
//  Copyright © 2020 Radu Ursache. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
	
	@IBOutlet weak var baseCurrencyLabel: UILabel!
	@IBOutlet weak var valueTextField: UITextField!
	@IBOutlet weak var lastUpdateLabel: UILabel!
	@IBOutlet weak var tableView: UITableView!
	
	var homeModel: HomeViewModel?
	var refreshTimer: Timer?

	override func viewDidLoad() {
		super.viewDidLoad()
		
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		self.refreshData()
	}
	
	override func setupBindings() {
		super.setupBindings()
		
		self.homeModel = HomeViewModel(parent: self, tableView: self.tableView, lastUpdatedLabel: self.lastUpdateLabel, valueTextField: self.valueTextField, baseCurrencyLabel: self.baseCurrencyLabel)
		
		self.fireTimer()
	}

	override func setupUI() {
		super.setupUI()
		
		self.navigationItem.title = "Currency Convertor"
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshData))
	}
	
	@objc func fireTimer() {
		// invalidate timer and start a new one so if refresh interval is changed, we respect that
		self.refreshTimer?.invalidate()
		self.refreshTimer = Timer.scheduledTimer(timeInterval: DataManager.sharedInstance.getRefreshInterval(), target: self, selector: #selector(self.fireTimer), userInfo: nil, repeats: false)
		self.refreshData()
	}
	
	@objc func refreshData() {
		self.homeModel?.getCurrencyData()
	}
}
