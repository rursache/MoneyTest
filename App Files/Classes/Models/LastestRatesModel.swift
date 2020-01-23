//
//  LastestRatesModel.swift
//  oMoneyTest
//
//  Created by Radu Ursache on 22/01/2020.
//  Copyright © 2020 Radu Ursache. All rights reserved.
//

import Foundation
import ObjectMapper

class LastestRatesModel: Mappable {
	var rates = [String: Double]()
	var base = String()
	private var responseDate = String()
	
	required init?(map: Map) {
		
	}
	
	func mapping(map: Map) {
		rates <- map["rates"]
		base <- map["base"]
		responseDate <- map["date"]
	}
	
	func getDate() -> Date? {
		return Constants.Helpers.backendDateFormatter.date(from: self.responseDate)
	}
	
	func getFormattedDate() -> String? {
		if let date = self.getDate() {
			return Constants.Helpers.generalDateFormatter.string(from: date)
		} else {
			return nil
		}
	}
}
