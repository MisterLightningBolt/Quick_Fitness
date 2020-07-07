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

let entityTypes: [String] = ["Settings", "Routine", "Exercise"]

class CoreDataManager {
	
	private static func searchEntities(entityName: String, name: String?) -> [NSManagedObject] {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
		
		var fetchedResults: [NSManagedObject]? = nil
		
		if name != nil && name != "*" {
			let predicate = NSPredicate(format: "name == %@", name!)
			request.predicate = predicate
		}
		
		do {
			try fetchedResults = context.fetch(request) as? [NSManagedObject]
			return fetchedResults!
		} catch {
			self.logErrorAndAbort(error: error)
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
	
	static func fetchSettings() -> Settings {
		let result = searchEntities(entityName: "Settings", name: nil)
		
		if result.isEmpty {
			// No settings saved. Make new settings.
			
			let appDelegate = UIApplication.shared.delegate as! AppDelegate
			let context = appDelegate.persistentContainer.viewContext
			return NSEntityDescription.insertNewObject(
				forEntityName: "Settings", into: context) as! Settings
		} else {
			return result[0] as! Settings
		}
	}
	
	static func storeExercise(name: String) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		
		let exercise = NSEntityDescription.insertNewObject(
			forEntityName: "Exercise", into:context)
		
		// Set the attribute values
		exercise.setValue(name, forKey: "name")
		
		// Commit the changes
		do {
			try context.save()
		} catch {
			self.logErrorAndAbort(error: error)
		}
	}
	
	static func clearCoreData() {
		for entityType in entityTypes {
			self.deleteEntities(ofType: entityType)
		}
    }
	
	static func deleteRequestResults(request: NSFetchRequest<NSFetchRequestResult>) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
		
		do {
			let fetchedResults = try context.fetch(request) as! [NSManagedObject]
            
            if fetchedResults.count > 0 {
                for result:AnyObject in fetchedResults {
                    context.delete(result as! NSManagedObject)
                }
            }
            try context.save()
            
		} catch {
			self.logErrorAndAbort(error: error)
        }
	}
	
	static func deleteEntities(ofType: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ofType)
        
		self.deleteRequestResults(request: request)
	}
	
	static func deleteExercise(name: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
		let predicate = NSPredicate(format: "name == %@", name)
		request.predicate = predicate
		
		self.deleteRequestResults(request: request)
	}
	
	static func deleteRoutine(name: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Routine")
		let predicate = NSPredicate(format: "name == %@", name)
		request.predicate = predicate
		
		self.deleteRequestResults(request: request)
	}
	
	static func logErrorAndAbort(error: Error) -> Never {
		let nserror = error as NSError
		NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
		abort()
	}
}

// Custom Error for handling query issues
enum FetchError: Error {
	case itemNotFound
	case duplicateItemsFound
}
