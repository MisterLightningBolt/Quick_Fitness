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
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
        tableView.dataSource = self
		
		// If we're loading an existing routine, load its properties.
		routineNameField.text = routine?.name ?? "Routine Name"
		exercises = routine?.getExerciseObjects() ?? []
		
		tableView.reloadData()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
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
		guard let routineName: String = routineNameField.text, !routineName.isEmpty, routineName != "Routine Name" else {
			self.routineCreationFailed(message: "Please enter a name for the routine.")
			return
		}
		var names: [String] = []
		for exercise in exercises {
			names.append(exercise.name!)
		}
		CoreDataManager.storeRoutine(name: routineName, exercises: names)
	}
	
	private func editRoutine() {
		CoreDataManager.editRoutine(routine: routine!, newName: routineNameField.text!, newExercises: CoreDataManager.getNames(ofExercises: self.exercises))
	}
	
	@IBAction func savePressed(_ sender: Any) {
		if routine == nil {
			self.createNewRoutine()
		} else {
			self.editRoutine()
		}
	}
	
	func addExercise(exercise: Exercise) {
		exercises.append(exercise)
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
