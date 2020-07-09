//
// Exercise+CoreDataClass.swift: HillAndrew-Project
// EID: awh772
// Course: CS371L
//
// Created by andrewhill on 7/8/20
// Copyright 2020 Andrew Hill. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(Exercise)
public class Exercise: NSManagedObject, NSCoding {
	public func encode(with coder: NSCoder) {
		coder.encode(self.name, forKey: "name")
	}
	
	convenience required public init?(coder: NSCoder) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		self.init(entity: NSEntityDescription(coder: coder)!, insertInto: context)
		name = coder.decodeObject(forKey: "name") as! String
	}
}
