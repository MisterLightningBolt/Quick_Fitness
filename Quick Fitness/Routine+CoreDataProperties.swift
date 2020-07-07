//
// Routine+CoreDataProperties.swift: HillAndrew-HW1
// EID: awh772
// Course: CS371L
//
// Created by andrewhill on 7/6/20
// Copyright 2020 Andrew Hill. All rights reserved.
//
//

import Foundation
import CoreData


extension Routine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Routine> {
        return NSFetchRequest<Routine>(entityName: "Routine")
    }

    @NSManaged public var name: String
    @NSManaged public var exercise: NSSet?

}

// MARK: Generated accessors for exercise
extension Routine {

    @objc(addExerciseObject:)
    @NSManaged public func addToExercise(_ value: Exercise)

    @objc(removeExerciseObject:)
    @NSManaged public func removeFromExercise(_ value: Exercise)

    @objc(addExercise:)
    @NSManaged public func addToExercise(_ values: NSSet)

    @objc(removeExercise:)
    @NSManaged public func removeFromExercise(_ values: NSSet)

}
