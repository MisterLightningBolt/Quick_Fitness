//
// Routine+CoreDataProperties.swift: HillAndrew-Project
// EID: awh772
// Course: CS371L
//
// Created by andrewhill on 7/8/20
// Copyright 2020 Andrew Hill. All rights reserved.
//
//

import Foundation
import CoreData


extension Routine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Routine> {
        return NSFetchRequest<Routine>(entityName: "Routine")
    }

    @NSManaged public var exercises: NSObject
    @NSManaged public var name: String

	public var exercisesArray: [String] {
		return exercises as! [String]
	}
}
