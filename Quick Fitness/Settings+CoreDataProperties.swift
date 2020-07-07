//
// Settings+CoreDataProperties.swift: HillAndrew-Project
// EID: awh772
// Course: CS371L
//
// Created by andrewhill on 7/6/20
// Copyright 2020 Andrew Hill. All rights reserved.
//
//

import Foundation
import CoreData


extension Settings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Settings> {
        return NSFetchRequest<Settings>(entityName: "Settings")
    }

    @NSManaged public var calendarNotificationsEnabled: Bool
    @NSManaged public var darkModeEnabled: Bool

}
