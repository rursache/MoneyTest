//
//  BaseViewController.swift
//  oMoneyTest
//
//  Created by Radu Ursache on 22/01/2020.
//  Copyright © 2020 Radu Ursache. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

		self.setupBindings()
		self.setupUI()
    }
    
	func setupBindings() {
		
	}
	
	func setupUI() {
		self.navigationItem.title = self.tabBarItem.title
	}

}
