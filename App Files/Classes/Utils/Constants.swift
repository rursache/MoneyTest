//
//  Constants.swift
//  oMoneyTest
//
//  Created by Radu Ursache on 22/01/2020.
//  Copyright © 2020 Radu Ursache. All rights reserved.
//

import Foundation
import UIKit

enum Environment: String {
    case development
    case production
    
    var baseURL: String {
        switch self {
			case .development : return "https://api.exchangeratesapi.io/"
			case .production  : return "https://api.exchangeratesapi.io/"
        }
    }
}

struct Configuration {
    static let environment: Environment = {
        return Environment.development
    }()
}

struct Constants {
    struct Config {
		static let defaultRefreshInterval: Double = 3
		static let defaultCurrency = "EUR"
	}
	
	struct Helpers {
		static let backendDateFormatter: DateFormatter = {
			let formatter = DateFormatter()
			formatter.dateFormat = "yyyy-MM-dd"
			return formatter
		}()
		
		static let generalDateFormatter: DateFormatter = {
			let formatter = DateFormatter()
			formatter.dateFormat = "dd.MM.YYYY"
			return formatter
		}()
		
		static let timestampDateFormatter: DateFormatter = {
			let formatter = DateFormatter()
			formatter.dateFormat = "dd.MM.YYYY HH:mm:ss"
			return formatter
		}()
	}
	
	struct System {
        static let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        static let appBuild = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? ""
        static let systemVersion = UIDevice.current.systemVersion
    }
    
    struct UserDefaultKeys {
		static let refreshRateInterval = "refreshRateInterval"
		static let defaultCurrency = "defaultCurrency"
    }
}

