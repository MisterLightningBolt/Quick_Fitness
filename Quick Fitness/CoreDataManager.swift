//
// CoreDataManager.swift: HillAndrew-Project
// EID: awh772
// Course: CS371L
//
// Created by andrewhill on 7/6/20
// Copyright 2020 Andrew Hill. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
	
	private static func searchEntities(entityName: String, name: String) -> [NSManagedObject] {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
		
		var fetchedResults: [NSManagedObject]? = nil
		
		let predicate = NSPredicate(format: "name == %@", name)
		request.predicate = predicate
		
		do {
			try fetchedResults = context.fetch(request) as? [NSManagedObject]
			return fetchedResults ?? []
		} catch {
			// if an error occurs
			let nserror = error as NSError
			NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
			abort()
		}
	}
	
	static func fetchSingleEntity(entityName: String, name: String) throws -> NSManagedObject {
		let fetchedResults = self.searchEntities(entityName: entityName, name: name)
		
		if fetchedResults.count == 0 {
			throw FetchError.itemNotFound
		} else if fetchedResults.count > 1 {
			// Names should be unique, never duplicated.
			throw FetchError.duplicateItemsFound
		}
		
		return fetchedResults[0]
	}
	
	static func fetchAllExercises() -> [Exercise] {
		return searchEntities(entityName: "Exercise", name: "*") as! [Exercise]
	}
	
	static func fetchExercise(name: String) throws -> Exercise {
		return try fetchSingleEntity(entityName: "Exercise", name: name) as! Exercise
	}
	
	static func fetchAllRoutines() -> [Routine] {
		return searchEntities(entityName: "Routine", name: "*") as! [Routine]
	}
	
	static func fetchRoutine(name: String) throws -> Routine {
		return try fetchSingleEntity(entityName: "Routine", name: name) as! Routine
	}
}

// Custom Error for handling query issues
enum FetchError: Error {
	case itemNotFound
	case duplicateItemsFound
}
