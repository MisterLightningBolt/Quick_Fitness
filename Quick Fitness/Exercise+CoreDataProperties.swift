//
// Exercise+CoreDataProperties.swift: HillAndrew-Project
// EID: awh772
// Course: CS371L
//
// Created by andrewhill on 7/7/20
// Copyright 2020 Andrew Hill. All rights reserved.
//
//

import Foundation
import CoreData


extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var name: String
    @NSManaged public var routines: NSSet

}

// MARK: Generated accessors for routines
extension Exercise {

    @objc(addRoutinesObject:)
    @NSManaged public func addToRoutines(_ value: Routine)

    @objc(removeRoutinesObject:)
    @NSManaged public func removeFromRoutines(_ value: Routine)

    @objc(addRoutines:)
    @NSManaged public func addToRoutines(_ values: NSSet)

    @objc(removeRoutines:)
    @NSManaged public func removeFromRoutines(_ values: NSSet)

}
