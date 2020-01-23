//
//  HistoryRatesModel.swift
//  oMoneyTest
//
//  Created by Radu Ursache on 22/01/2020.
//  Copyright © 2020 Radu Ursache. All rights reserved.
//

import Foundation
import ObjectMapper

class HistoryRatesModel: Mappable {
	var rates = [String: [String: Double]]()
	var base = String()
	private var responseStartDate = String()
	private var responseEndDate = String()
	
	required init?(map: Map) {
		
	}
	
	func mapping(map: Map) {
		rates <- map["rates"]
		base <- map["base"]
		responseStartDate <- map["start_at"]
		responseEndDate <- map["end_at"]
	}
	
	func getDate(startDate: Bool) -> Date? {
		return Constants.Helpers.backendDateFormatter.date(from: startDate ? self.responseStartDate : self.responseEndDate)
	}
	
	func getFormattedDate(date: Date) -> String {
		return Constants.Helpers.generalDateFormatter.string(from: date)
	}
}
