//
//  ApiManager.swift
//  oMoneyTest
//
//  Created by Radu Ursache on 22/01/2020.
//  Copyright © 2020 Radu Ursache. All rights reserved.
//

import Foundation
import Alamofire

class APIManager {
	enum Router: URLConvertible {
		case LatestRates(baseCurrency: String = "EUR")
		case History(startDate: Date = Date(), endDate: Date = Date())
        
        var path: String {
            switch self {
            case .LatestRates:
                return "latest"
				
			case .History:
				return "history"
			}
        }
		
		func getParameters() -> Parameters {
			switch self {
			case .LatestRates(let baseCurrency):
				return ["base": baseCurrency]
				
			case .History(let startDate, let endDate):
				let dateFormatter = DateFormatter()
				dateFormatter.dateFormat = "yyyy-MM-dd"
				
				return ["start_at": dateFormatter.string(from: startDate),
						"end_at": dateFormatter.string(from: endDate)]

			}
		}
        
        func asURL() throws -> URL {
			return try Configuration.environment.baseURL.asURL().appendingPathComponent(path)
        }
    }
    
    static let sharedInstance = APIManager()
    
    var defaultManager: Alamofire.SessionManager!
    let sessionConfiguration = URLSessionConfiguration.default
    
    init() {
        let serverTrustPolicies = [String: ServerTrustPolicy]()
        self.sessionConfiguration.timeoutIntervalForRequest = 120
        self.sessionConfiguration.timeoutIntervalForResource = 120
        
        let sessionManager = SessionManager(configuration: sessionConfiguration, serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
        self.defaultManager = sessionManager
    }
    
    func sendJSONRequest(method: HTTPMethod, path: URLConvertible, parameters: Parameters?) -> DataRequest {
        let headers = ["Content-Type" : "application/json"]
        if method == .get {
			return self.sendJSONRequest(method: method, path: path, parameters: parameters, encoding: URLEncoding.default, headers: headers)
        } else {
            return self.sendJSONRequest(method: method, path: path, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        }
    }
    
	private func sendJSONRequest(method: HTTPMethod, path: URLConvertible, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders) -> DataRequest {
		return self.defaultManager.request(path, method: method, parameters: parameters, encoding: encoding, headers: headers)
	}
}


