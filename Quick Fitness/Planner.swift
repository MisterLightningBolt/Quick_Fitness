//
// Planner.swift: HillAndrew-Project
// EID: awh772
// Course: CS371L
//
// Created by andrewhill on 6/18/20
// Copyright 2020 Andrew Hill. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

let routineEventCellID: String = "RoutineEventCell"

class Planner: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet weak var datePicker: UIDatePicker!
	@IBOutlet weak var tableView: UITableView!
	
	var routines: [Routine] = CoreDataManager.fetchAllRoutines()
	var checkedRoutine: Routine?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
        tableView.dataSource = self

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		// Reload any new routines
		routines = CoreDataManager.fetchAllRoutines()
		tableView.reloadData()
	}
	
	func toggleCheckCell(at: IndexPath) {
		guard let cell = tableView.cellForRow(at: at) else {return}
		
		if cell.accessoryType == .none {
			checkedRoutine = routines[at.row]
			cell.accessoryType = .checkmark
		} else {
			checkedRoutine = nil
			cell.accessoryType = .none
		}
	}
	
    // MARK: - Table view data source

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return routines.count + 1
    }
    
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Configure the cell...
		let row = indexPath.row
		
		// New routine cell
		if row == routines.count {
			return loadNewRoutineCell(tableView, cellForRowAt: indexPath)
		} else {
			return loadRoutineEventCell(tableView, cellForRowAt: indexPath)
		}
    }
    
	func loadNewRoutineCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: newRoutineCellID, for: indexPath)
		cell.textLabel?.text = "New Routine"
		return cell
	}
	
	func loadRoutineEventCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: routineEventCellID, for: indexPath)
		let routine: Routine = routines[indexPath.row]
		cell.textLabel?.text = routine.name
		cell.detailTextLabel?.text = "Number of exercises: \(routine.exercisesArray.count)"
		cell.accessoryType = routine == checkedRoutine ? .checkmark : .none
		return cell
	}
	
	// Cannot delete new routine cell
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return indexPath.row != routines.count
	}
	
	// Code to delete cell on swipe
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			
			// Delete routine from list
			let removedRoutine = routines.remove(at: indexPath.row)
			
			// Delete routine from core data
			CoreDataManager.deleteRoutine(name: removedRoutine.name!)
			
			// Delete routine from table
			tableView.deleteRows(at: [indexPath], with: .fade)
		} else if editingStyle == .insert {
			// Insertion is already handled elsewhere.
			return
		}
	}

	// Make checkmark indicate selected routine.
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		
		// Don't check "New Routine" cell
		if indexPath.row != routines.count {
			// Toggle check selected routine
			self.toggleCheckCell(at: indexPath)
		}
	}
	
    // Support conditional rearranging of the table view
	// Cannot reorder new routine cell
	func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return indexPath.row != routines.count
	}
	
	func showAlert(title: String, message: String) {
		let controller = UIAlertController(
			title: title,
			message: message,
			preferredStyle: .alert)
		controller.addAction(UIAlertAction(
		title: "OK",
		style: .default,
		handler: nil))
		present(controller, animated: true, completion: nil)
	}
	
	func eventCreationFailed(message: String) {
		showAlert(title: "Failed to add event to calendar.", message: message)
	}
	
	func eventCreationSucceeded() {
		showAlert(title: "Event added to calendar.", message: "Title of event: \"Quick Fitness: \(checkedRoutine!.name!)\"")
	}
	
	// Attempt to save event to calendar
	@IBAction func donePressed(_ sender: Any) {
		// Assure routine selected
		if checkedRoutine == nil {
			self.eventCreationFailed(message: "Please select a routine.")
			return
		}
		
		// Add event to calendar
		let startDate = datePicker.date
		let endDate = startDate.addingTimeInterval(60*60) // 1 hour by default
		addEvent(title: "Quick Fitness: \(checkedRoutine!.name!)", startDate: startDate, endDate: endDate)
	}
	
	func addAlarm(toEvent: EKEvent) {
		if CoreDataManager.fetchSettings().calendarNotificationsEnabled {
			toEvent.addAlarm(EKAlarm(absoluteDate: toEvent.startDate))
		}
	}
	
	// MARK: - Modified Class Demo 23 Code
	// The following code was taken from Class Demo 23. Modifications were made.
	
	var savedEventId:String = ""
    let eventStore = EKEventStore()
    
    func createEvent(title:String, startDate: Date, endDate: Date) {
        
        // use the instance of EKEventStore, which enables me to perform
        // read and write operations on the user's calendar and reminder lists
        
        let event = EKEvent(eventStore: eventStore)
        
        // construct the event
        event.title = title
        event.startDate = startDate as Date?
        event.endDate = endDate as Date?
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
			// If alarms are enabled, add one to event
			self.addAlarm(toEvent: event)
			
			// save the event to the calendar
            // "span" means either "just this one" or "all subsequent events"
            try eventStore.save(event, span: .thisEvent)
			// save an identifier so we can refer to this event later
            savedEventId = event.eventIdentifier
			
			// Notify user that event was added to calendar
			self.eventCreationSucceeded()
        } catch {
			NSLog("Error creating event: \(error)")
			
			// Notify user that event couldn't be added to calendar.
			self.eventCreationFailed(message: "Internal error.")
        }
    }

    func addEvent(title:String, startDate: Date, endDate: Date) {
		if (EKEventStore.authorizationStatus(for: .event) !=
			EKAuthorizationStatus.authorized) {
			self.eventStore.requestAccess(
				to: .event,
				completion: {
					granted, error in
					self.createEvent(title: title,startDate: startDate, endDate: endDate)
			})
		} else {
			self.createEvent(title: title, startDate: startDate, endDate: endDate)
		}
    }
}
