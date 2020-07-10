//
// Exercise+CoreDataProperties.swift: HillAndrew-Project
// EID: awh772
// Course: CS371L
//
// Created by andrewhill on 7/8/20
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

}
