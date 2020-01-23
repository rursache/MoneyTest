//
//  oMoneyTestTests.swift
//  oMoneyTestTests
//
//  Created by Radu Ursache on 22/01/2020.
//  Copyright © 2020 Radu Ursache. All rights reserved.
//

import XCTest
@testable import MoneyTest
@testable import Charts

class MoneyTestTests: XCTestCase {
	
	let apiClientInstance = APIClient.sharedInstance

    override func setUp() {
		super.setUp()
    }

    override func tearDown() {
		super.tearDown()
    }
	
	func testRatesAPIcall() {
		self.apiClientInstance.getRates(base: DataManager.sharedInstance.getDefaultCurrency()) { (ratesModel, error) in
			
			// test for model mapping, item count
			XCTAssertNotNil(ratesModel)
			XCTAssertNotNil(ratesModel?.rates)
			XCTAssertGreaterThan(ratesModel!.rates.count, 0)
			
			self.testSetRandomCurrency()
		}
	}
	
	func testHistoryAPIcall() {
		let baseCurrency = DataManager.sharedInstance.getDefaultCurrency()
		
		self.apiClientInstance.getHistory(base: baseCurrency, startDate: self.generateRandomDate(days: Int(arc4random_uniform(30)))!, endDate: self.generateRandomDate(days: Int(arc4random_uniform(30)), past: false)!) { (historyModel, error) in
			
			// test for model mapping, item count
			XCTAssertNotNil(historyModel)
			XCTAssertNotNil(historyModel?.rates)
			XCTAssertGreaterThan(historyModel!.rates.count, 0)
			
			// build chart data
			var cleanDataSource = [[String: Double]]()
			for key in historyModel!.rates.keys {
				if let valueForBaseCurrency = historyModel!.rates[key]?[baseCurrency] {
					cleanDataSource.append([key: valueForBaseCurrency])
				}
			}
			cleanDataSource = cleanDataSource.sorted { $0.keys.first! < $1.keys.first! }
			
			// create chart items
			var chartDataSource = [ChartDataEntry]()
			for item in cleanDataSource {
				guard let dateString = item.keys.first,
						let date = Constants.Helpers.backendDateFormatter.date(from: dateString),
							let itemValue = item[dateString] else {
					break
				}
				chartDataSource.append(ChartDataEntry(x: date.timeIntervalSince1970, y: itemValue))
			}
			
			// test if we got chart items equal to response items
			XCTAssertEqual(chartDataSource.count, historyModel!.rates.count)
		}
	}
	
	func testSetRandomCurrency() {
		let availableCurrencies = DataManager.sharedInstance.getAvailableCurrencies()
		DataManager.sharedInstance.saveDefaultCurrency(currency: availableCurrencies[Int(arc4random_uniform(UInt32(availableCurrencies.count)))])
		
		XCTAssertNotNil(UserDefaults.standard.string(forKey: Constants.UserDefaultKeys.defaultCurrency))
	}
}

extension MoneyTestTests {
	func generateRandomDate(days: Int, past: Bool = true) -> Date? {
        let day = arc4random_uniform(UInt32(days))+1
        let hour = arc4random_uniform(23)
        let minute = arc4random_uniform(59)
        
        let today = Date(timeIntervalSinceNow: 0)
        let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        var offsetComponents = DateComponents()
		offsetComponents.day = (past ? -1 : 1) * Int(day - 1)
        offsetComponents.hour = -1 * Int(hour)
        offsetComponents.minute = -1 * Int(minute)
        
        return gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0))
    }
}
