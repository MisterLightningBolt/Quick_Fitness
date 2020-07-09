//
// NavigationController.swift: HillAndrew-Project
// EID: awh772
// Course: CS371L
//
// Created by andrewhill on 7/9/20
// Copyright 2020 Andrew Hill. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
		self.overrideUserInterfaceStyle = CoreDataManager.darkModeEnabled ? .dark : .light
    }

}
