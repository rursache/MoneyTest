//
//  DataManager.swift
//  oMoneyTest
//
//  Created by Radu Ursache on 23/01/2020.
//  Copyright © 2020 Radu Ursache. All rights reserved.
//

import Foundation
import UIKit

class DataManager {
	static let sharedInstance = DataManager()
	
	private let userDefaults = UserDefaults.standard
	private var availableCurrencies: [String]?
	
	func saveRefreshInterval(interval: Double) {
		self.userDefaults.set(interval, forKey: Constants.UserDefaultKeys.refreshRateInterval)
	}
	
	func getRefreshInterval() -> Double {
		if self.userDefaults.object(forKey: Constants.UserDefaultKeys.refreshRateInterval) != nil {
			return self.userDefaults.double(forKey: Constants.UserDefaultKeys.refreshRateInterval)
		} else {
			return Constants.Config.defaultRefreshInterval
		}
	}
	
	func saveDefaultCurrency(currency: String) {
		self.userDefaults.set(currency, forKey: Constants.UserDefaultKeys.defaultCurrency)
	}
	
	func getDefaultCurrency() -> String {
		return self.userDefaults.string(forKey: Constants.UserDefaultKeys.defaultCurrency) ?? Constants.Config.defaultCurrency
	}
	
	func setAvailableCurrencies(currencies: [String]) {
		var currencyArray = currencies
		if !currencyArray.contains("EUR") {
			currencyArray.insert("EUR", at: 0)
		}
		
		self.availableCurrencies = currencyArray
	}
	
	func getAvailableCurrencies() -> [String] {
		return self.availableCurrencies ?? [Constants.UserDefaultKeys.defaultCurrency]
	}
}
