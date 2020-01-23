//
//  Extensions.swift
//  oMoneyTest
//
//  Created by Radu Ursache on 22/01/2020.
//  Copyright © 2020 Radu Ursache. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
	enum ViewControllers: String {
		case home = "homeVC"
		case history = "historyVC"
		case settings = "settingsVC"
	}
	
    enum StoryBoard: String {
        case main
		
        func instance(_ vc: String) -> UIViewController {
            return UIStoryboard(name: self.rawValue, bundle: Bundle.main).instantiateViewController(withIdentifier: vc)
        }
    }
    
    class func Home() -> HomeViewController {
		return StoryBoard.main.instance(ViewControllers.home.rawValue) as! HomeViewController
    }
	
	class func History() -> HistoryViewController {
		return StoryBoard.main.instance(ViewControllers.history.rawValue) as! HistoryViewController
    }
	
	class func Settings() -> SettingsViewController {
		return StoryBoard.main.instance(ViewControllers.settings.rawValue) as! SettingsViewController
    }
}

extension UITextField {
    @IBInspectable var doneAccessory: Bool{
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
}
