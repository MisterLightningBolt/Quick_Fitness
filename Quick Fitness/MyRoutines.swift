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
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)		
		// Reload any new routines
		routines = CoreDataManager.fetchAllRoutines()
		tableView.reloadData()
	}

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return routines.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Configure the cell...
		let row = indexPath.row
		
		// New routine cell
		if row == routines.count {
			return loadNewRoutineCell(tableView, cellForRowAt: indexPath)
		} else {
			return loadRoutineCell(tableView, cellForRowAt: indexPath)
		}
    }
    
	func loadNewRoutineCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: newRoutineCellID, for: indexPath)
		cell.textLabel?.text = "New Routine"
		return cell
	}
	
	func loadRoutineCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: routineCellID, for: indexPath)
		let routine = routines[indexPath.row]
		cell.textLabel?.text = routine.name
		cell.detailTextLabel?.text = "Number of exercises: \(routine.exercisesArray.count)"
		return cell
	}
	
	// Cannot delete new routine cell
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return indexPath.row != routines.count
	}
	
	// Code to delete cell on swipe
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
