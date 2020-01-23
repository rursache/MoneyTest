//
//  ApiClient.swift
//  oMoneyTest
//
//  Created by Radu Ursache on 22/01/2020.
//  Copyright © 2020 Radu Ursache. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class APIClient {
	static let sharedInstance = APIClient()
	
	func getRates(base: String, completion: @escaping (_ response: LastestRatesModel?, _ error: Error?) -> Void) {
		APIManager.sharedInstance.sendJSONRequest(method: .get, path: APIManager.Router.LatestRates(),
												  parameters: APIManager.Router.getParameters(.LatestRates(baseCurrency: base))()).responseObject { (response: DataResponse<LastestRatesModel>) in
			if let validResponse = response.value {
				completion(validResponse, nil)
			} else {
				completion(nil, response.error)
			}
		}
	}
	
	func getHistory(base: String, startDate: Date, endDate: Date, completion: @escaping (_ response: HistoryRatesModel?, _ error: Error?) -> Void) {
		APIManager.sharedInstance.sendJSONRequest(method: .get, path: APIManager.Router.History(),
												  parameters: APIManager.Router.getParameters(.History(startDate: startDate, endDate: endDate))()).responseObject { (response: DataResponse<HistoryRatesModel>) in
			if let validResponse = response.value {
				completion(validResponse, nil)
			} else {
				completion(nil, response.error)
			}
		}
	}
}
