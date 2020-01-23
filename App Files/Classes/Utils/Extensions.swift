//
//  Extensions.swift
//  oMoneyTest
//
//  Created by Radu Ursache on 22/01/2020.
//  Copyright © 2020 Radu Ursache. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
	enum ViewControllers: String {
		case home = "homeVC"
		case history = "historyVC"
		case settings = "settingsVC"
	}
	
    enum StoryBoard: String {
        case main = "Main"
		
        func instance(_ vc: String) -> UIViewController {
            return UIStoryboard(name: self.rawValue, bundle: Bundle.main).instantiateViewController(withIdentifier: vc)
        }
    }
    
    class func getHomeVC() -> HomeViewController {
		return StoryBoard.main.instance(ViewControllers.home.rawValue) as! HomeViewController
    }
	
	class func getHistoryVC() -> HistoryViewController {
		return StoryBoard.main.instance(ViewControllers.history.rawValue) as! HistoryViewController
    }
	
	class func getSettingsVC() -> SettingsViewController {
		return StoryBoard.main.instance(ViewControllers.settings.rawValue) as! SettingsViewController
    }
}

extension UITextField {
	// -- https://medium.com/swift2go/swift-add-keyboard-done-button-using-uitoolbar-c2bea50a12c7
    @IBInspectable var doneAccessory: Bool {
        get {
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone {
                addDoneButtonOnKeyboard()
            }
        }
    }

    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
	// --
}

extension Date {
	// -- https://stackoverflow.com/a/20158940/1880111
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
	// --
}
