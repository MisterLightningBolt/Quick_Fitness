//
// MyRoutines.swift: HillAndrew-Project
// EID: awh772
// Course: CS371L
//
// Created by andrewhill on 6/19/20
// Copyright 2020 Andrew Hill. All rights reserved.
//

import UIKit
import CoreData

let routineCellID: String = "RoutineCell"
let newRoutineCellID: String = "NewRoutineCell"
let routineSelectedSegueID: String = "RoutineSelectedSegue"

class MyRoutines: UITableViewController {
	var routines: [Routine] = CoreDataManager.fetchAllRoutines()
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		// Reload any new routines
		routines = CoreDataManager.fetchAllRoutines()
		tableView.reloadData()
	}

    // MARK: - Table view

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return routines.count + 1 // +1 for the "New Routine" cell
    }
    
	// Load a cell on the given row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if indexPath.row == routines.count {
			// "New Routine" cell
			return loadNewRoutineCell(tableView, cellForRowAt: indexPath)
		} else {
			// Load cell that contains an existing routine
			return loadRoutineCell(tableView, cellForRowAt: indexPath)
		}
    }
    
	// Load a cell that can be used to create a new routine
	func loadNewRoutineCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: newRoutineCellID, for: indexPath)
		cell.textLabel?.text = "New Routine"
		return cell
	}
	
	// Load a cell which contains info about a routine from core data
	func loadRoutineCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: routineCellID, for: indexPath)
		let routine = routines[indexPath.row]
		cell.textLabel?.text = routine.name
		cell.detailTextLabel?.text = "Number of exercises: \(routine.exercisesArray.count)"
		return cell
	}
	
	// Cannot delete "New Routine" cell
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return indexPath.row != routines.count
	}
	
	// Delete cell (and its routine) on swipe
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			
			// Delete routine from list
			let removedRoutine = routines.remove(at: indexPath.row)
			
			// Delete routine from core data
			CoreDataManager.deleteRoutine(name: removedRoutine.name)
			
			// Delete routine from table
			tableView.deleteRows(at: [indexPath], with: .fade)
		} else if editingStyle == .insert {
			// Insertion is already handled elsewhere.
			return
		}
	}

    // MARK: - Navigation

    // Pass the routine to the routine maker
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == routineSelectedSegueID {
			let dest = segue.destination as! RoutineMaker
			guard let row: Int = tableView.indexPathForSelectedRow?.row else {
				dest.routine = nil
				return
			}
			dest.routine = routines[row]
		}
    }
}
