//
// SettingsTableViewController.swift: HillAndrew-Project
// EID: awh772
// Course: CS371L
//
// Created by andrewhill on 7/6/20
// Copyright 2020 Andrew Hill. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
	@IBOutlet weak var calendarAlertsSwitch: UISwitch!
	@IBOutlet weak var darkModeSwitch: UISwitch!
	
	var mySettings: Settings = CoreDataManager.fetchSettings()
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		calendarAlertsSwitch.isOn = CoreDataManager.calendarNotificationsEnabled
		darkModeSwitch.isOn = CoreDataManager.darkModeEnabled
		overrideUserInterfaceStyle = CoreDataManager.darkModeEnabled ? .dark : .light
	}
	
	@IBAction func calendarNotificationsChanged(_ sender: Any) {
		CoreDataManager.storeSetting(forKey: "calendarNotificationsEnabled", value: calendarAlertsSwitch.isOn)
	}
	
	@IBAction func darkModeChanged(_ sender: Any) {
		CoreDataManager.storeSetting(forKey: "darkModeEnabled", value: darkModeSwitch.isOn)
		overrideUserInterfaceStyle = CoreDataManager.darkModeEnabled ? .dark : .light
		self.navigationController?.overrideUserInterfaceStyle = CoreDataManager.darkModeEnabled ? .dark : .light
	}
}
