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
	
	// Load new exercises while retaining selected data
	override func viewWillAppear(_ animated: Bool) {
		guard let selectedPaths = self.tableView.indexPathsForSelectedRows else {
			self.fetchAndReload()
			return
		}
		
		let oldCount: Int = exercises.count
		self.fetchAndReload()
		
		for selectedPath in selectedPaths {
			
			// Don't reselect "New Exercise"
			if selectedPath.row != oldCount {
				tableView.selectRow(at: selectedPath, animated: false, scrollPosition: .none)
			}
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return exercises.count + 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		// Configure the cell...
		let row = indexPath.row
		
		if row == exercises.count {
			return loadNewExerciseCell(tableView, cellForRowAt: indexPath)
		} else {
			return loadExerciseCell(tableView, cellForRowAt: indexPath)
		}
	}
	
	func loadNewExerciseCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: newExerciseCellID, for: indexPath)
		cell.textLabel?.text = "New Exercise"
		return cell
	}
	
	func loadExerciseCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: exerciseSelectCellID, for: indexPath)
		let exercise = exercises[indexPath.row]
		cell.textLabel?.text = exercise.name
		return cell
	}

	// Code to delete cell on swipe
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			
			// Delete exercise from list
			let removedExercise = exercises.remove(at: indexPath.row)
			
			// Delete exercise from core data
			CoreDataManager.deleteExercise(name: removedExercise.name)
			
			// Delete exercise from table
			tableView.deleteRows(at: [indexPath], with: .fade)
		} else if editingStyle == .insert {
			// Insertion is already handled elsewhere.
			return
		}
	}
	
	// Add all selected exercises to delegate and pop view
	@IBAction func donePressed(_ sender: Any) {
		// Add selected exercises to delegate
		let selectedIndexPaths = self.tableView.indexPathsForSelectedRows ?? []
		for selectedPath in selectedIndexPaths {
			delegate?.addExercise(exercise: exercises[selectedPath.row])
		}
		// Pop view
		self.navigationController?.popViewController(animated: true)
	}
	
	// Cannot delete new exercise cell
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return indexPath.row != exercises.count
	}
	
	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == exerciseSelectToExerciseMakerSegueID {
			let dest = segue.destination as! ExerciseMaker
			
		}
	}

}
