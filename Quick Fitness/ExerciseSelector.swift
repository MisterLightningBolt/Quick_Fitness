//
// MyExercises.swift: HillAndrew-Project
// EID: awh772
// Course: CS371L
//
// Created by andrewhill on 6/18/20
// Copyright 2020 Andrew Hill. All rights reserved.
//

import UIKit

let exerciseSelectCellID: String = "ExerciseSelectCell"
let newExerciseCellID: String = "NewExerciseCell"
let exerciseSelectToExerciseMakerSegueID: String = "ExerciseSelectToExerciseMaker"

class ExerciseSelector: UIViewController, UITableViewDataSource, UITableViewDelegate {
	@IBOutlet weak var tableView: UITableView!
	
	var delegate: AddsExercises?
	var exercises: [Exercise] = CoreDataManager.fetchAllExercises()
	var checkedExercises: [Exercise] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		self.fetchAndReload()
	}
	
	private func fetchAndReload() {
		exercises = CoreDataManager.fetchAllExercises()
		tableView.reloadData()
	}
	
	// Load new exercises while retaining selections
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.fetchAndReload()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return exercises.count + 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let row = indexPath.row
		
		// Determine which type of cell to load
		if row == exercises.count {
			return loadNewExerciseCell(tableView, cellForRowAt: indexPath)
		} else {
			return loadExerciseCell(tableView, cellForRowAt: indexPath)
		}
	}

	func toggleCheckCell(at: IndexPath) {
		guard let cell = (tableView.cellForRow(at: at) as? ExerciseTableViewCell) else {return}
		
		if cell.accessoryType == .none {
			checkedExercises.append(cell.exercise)
			cell.accessoryType = .checkmark
		} else {
			checkedExercises.removeAll(where: {$0.name == cell.exercise.name})
			cell.accessoryType = .none
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		
		if indexPath.row != exercises.count {
			self.toggleCheckCell(at: indexPath)
		}
	}
	
	func loadNewExerciseCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: newExerciseCellID, for: indexPath)
		cell.textLabel?.text = "New Exercise"
		return cell
	}
	
	func loadExerciseCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: exerciseSelectCellID, for: indexPath)
		let row = indexPath.row
		let exercise = exercises[row]
		
		cell.textLabel?.text = exercise.name
		(cell as! ExerciseTableViewCell).exercise = exercise
		
		cell.accessoryType = checkedExercises.contains(exercise) ? .checkmark : .none
		
		return cell
	}

	// Code to delete cell on swipe
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			
			// Delete exercise from list
			let removedExercise = exercises.remove(at: indexPath.row)
			
			// Delete exercise from core data
			CoreDataManager.deleteExercise(name: removedExercise.name!)
			
			// Delete exercise from table
			tableView.deleteRows(at: [indexPath], with: .fade)
		} else if editingStyle == .insert {
			// Insertion is already handled elsewhere.
			return
		}
	}
	
	func getCheckedExercises() -> [Exercise] {
		return self.checkedExercises
	}
	
	// Add all selected exercises to delegate and pop view
	@IBAction func donePressed(_ sender: Any) {
		// Add checked exercises to delegate
		for exercise in self.getCheckedExercises() {
			delegate?.addExercise(exercise: exercise)
		}
		// Pop view
		self.navigationController?.popViewController(animated: true)
	}
	
	// Cannot delete new exercise cell
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return indexPath.row != exercises.count
	}
}
