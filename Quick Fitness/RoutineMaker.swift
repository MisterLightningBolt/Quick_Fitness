//
// RoutineMaker.swift: HillAndrew-Project
// EID: awh772
// Course: CS371L
//
// Created by andrewhill on 6/18/20
// Copyright 2020 Andrew Hill. All rights reserved.
//

import UIKit
let exerciseCellID: String = "ExerciseCell"
let addExerciseCellID: String = "AddExerciseCell"
let routineMakerToExerciseSelectorID: String = "RoutineMakerToExerciseSelector"

class RoutineMaker: UIViewController, UITableViewDataSource, UITableViewDelegate, AddsExercises {
	@IBOutlet weak var routineNameField: UITextField!
	@IBOutlet weak var tableView: UITableView!
	
	var routine: Routine?
	var exercises: [Exercise] = []
	var unsavedChanges: Bool = false
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
        tableView.dataSource = self
		
		// Customize back button for use with save warning
		self.navigationItem.hidesBackButton = true
		let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
		
		// If we're loading an existing routine, load its properties.
		routineNameField.text = routine?.name ?? nil
		exercises = routine?.getExerciseObjects() ?? []
		
		tableView.reloadData()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
	}
	
	@objc func back(sender: UIBarButtonItem) {
        // If unsaved changes are present, warn user before going back.
		
		if unsavedChanges {
			let controller = UIAlertController(
				title: "Exiting with unsaved changes",
				message: "Are you sure you want to go back? Any changes will not be saved.",
				preferredStyle: .alert)
			controller.addAction(UIAlertAction(
			title: "Cancel",
			style: .cancel,
			handler: nil))
			controller.addAction(UIAlertAction(
			title: "Continue",
			style: .destructive,
			handler: {
				(action) in self.navigationController?.popViewController(animated: true)
			}))
			present(controller, animated: true, completion: nil)
		} else {
			// Go back to the previous ViewController
			self.navigationController?.popViewController(animated: true)
		}
    }
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return exercises.count + 1
    }
    
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Configure the cell...
		let row = indexPath.row
		
		if row == exercises.count {
			return loadAddExerciseCell(tableView, cellForRowAt: indexPath)
		} else {
			return loadExerciseCell(tableView, cellForRowAt: indexPath)
		}
    }
    
	func loadAddExerciseCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: addExerciseCellID, for: indexPath)
		cell.textLabel?.text = "Add Exercise"
		return cell
	}
	
	func loadExerciseCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: exerciseCellID, for: indexPath)
		let exercise = exercises[indexPath.row]
		cell.textLabel?.text = exercise.name
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func routineCreationFailed(message: String) {
		let controller = UIAlertController(
			title: "Failed to create routine.",
			message: message,
			preferredStyle: .alert)
		controller.addAction(UIAlertAction(
		title: "OK",
		style: .default,
		handler: nil))
		present(controller, animated: true, completion: nil)
	}
	
	private func createNewRoutine() {
		let routineName: String = routineNameField.text!
		
		var names: [String] = []
		for exercise in exercises {
			names.append(exercise.name!)
		}
		CoreDataManager.storeRoutine(name: routineName, exercises: names)
		unsavedChanges = false
		
		do {
			routine = try CoreDataManager.fetchRoutine(name: routineName)
		} catch {
			// Stored routine but couldn't fetch it. Should not happen.
			NSLog("\(error)")
		}
		
	}
	
	private func editRoutine() {
		CoreDataManager.editRoutine(routine: routine!, newName: routineNameField.text!, newExercises: CoreDataManager.getNames(ofExercises: self.exercises))
		unsavedChanges = false
	}
	
	@IBAction func savePressed(_ sender: Any) {
		guard let routineName: String = routineNameField.text, !routineName.isEmpty, routineName != "Routine Name" else {
			self.routineCreationFailed(message: "Please enter a name for the routine.")
			return
		}
		
		if routine == nil || routine!.name != routineName {
			self.createNewRoutine()
		} else {
			self.editRoutine()
		}
	}
	
	func addExercise(exercise: Exercise) {
		exercises.append(exercise)
		unsavedChanges = true
	}
	
	// Cannot delete add exercise cell
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return indexPath.row != exercises.count
	}
	
	// Code to delete cell on swipe
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			
			// Delete exercise from list
			_ = exercises.remove(at: indexPath.row)
			unsavedChanges = true
			
			// Delete exercise from table
			tableView.deleteRows(at: [indexPath], with: .fade)
		} else if editingStyle == .insert {
			// Insertion is already handled elsewhere.
			return
		}
	}
	
	// Support conditional rearranging of the table view
	// Cannot reorder add exercise cell
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return indexPath.row != exercises.count
	}
	
	// code to enable tapping on the background to remove software keyboard
	
	func textFieldShouldReturn(textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
		if segue.identifier == routineMakerToExerciseSelectorID {
			let dest = segue.destination as! ExerciseSelector
			dest.delegate = self
		}
    }

}
