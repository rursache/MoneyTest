//
//  HomeCell.swift
//  oMoneyTest
//
//  Created by Radu Ursache on 22/01/2020.
//  Copyright © 2020 Radu Ursache. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {
	
    override func awakeFromNib() {
        super.awakeFromNib()
    }
	
	func loadData(currencyName: String, currencyValue: Double) {
		self.textLabel?.text = currencyName
		
		// add currency symbol if its different than currency code
		if let currencySymbol = NSLocale(localeIdentifier: currencyName).displayName(forKey: NSLocale.Key.currencySymbol, value: currencyName) {
			if currencySymbol != currencyName {
				self.textLabel?.text = "\(currencyName) (\(currencySymbol))"
			}
		}
		
		self.detailTextLabel?.text = String(format: "%.3f", currencyValue)
		self.imageView?.image = UIImage(named: currencyName.lowercased())
	}

	class func getIdentifier() -> String {
		return "homeCell"
	}
	
}
